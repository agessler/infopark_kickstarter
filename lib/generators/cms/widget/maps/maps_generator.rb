module Cms
  module Generators
    module Widget
      class MapsGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        SUPPORTED_PROVIDER = %w(google_maps)

        class_option :provider,
          type: :string,
          default: 'google_maps',
          desc: "Select what maps provider to use. (#{SUPPORTED_PROVIDER.join(' | ')})"

        def validate_provider
          unless SUPPORTED_PROVIDER.include?(options[:provider])
            puts 'Please choose a supported provider. See options for more details.'
            puts

            self.class.help(self)

            exit
          end
        end

        def run_generator_for_selected_provider
          generator = "cms:widget:maps:#{options[:provider]}"

          Rails::Generators.invoke(generator, args, behavior: behavior)
        end
      end
    end
  end
end
