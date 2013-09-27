module Cms
  module Generators
    module Component
      class TrackingGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        SUPPORTED_PROVIDER = %w(google_analytics)

        class_option :provider,
          type: :string,
          default: SUPPORTED_PROVIDER.first,
          desc: "Select what tracking provider to use. (#{SUPPORTED_PROVIDER.join(' | ')})"

        def validate_provider
          unless SUPPORTED_PROVIDER.include?(provider)
            puts 'Please choose a supported provider. See options for more details.'
            puts

            self.class.help(self)

            exit
          end
        end

        def run_generator_for_selected_provider
          Rails::Generators.invoke("cms:component:tracking:#{provider}", args, behavior: behavior)
        end


        private

        def provider
          options[:provider]
        end
      end
    end
  end
end
