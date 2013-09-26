module Cms
  module Generators
    module Api
      class ModelGenerator < ::Rails::Generators::NamedBase
        Rails::Generators.hide_namespace(self.namespace)

        include Actions

        source_root File.expand_path('../templates', __FILE__)

        attr_accessor :attributes
        attr_accessor :preset_attributes
        attr_accessor :mandatory_attributes
        attr_accessor :page

        def initialize(options = {}, config = {})
          yield self if block_given?

          super([name], options, config)

          self.invoke_all
        end

        def create_model_file
          template('model.rb', path)
        end

        def turn_model_into_page
          if page?
            uncomment_lines(path, 'include Page')
          end
        end

        private

        def page?
          @page.nil? ? false : @page
        end

        def attributes
          @attributes ||= []
        end

        def preset_attributes
          @preset_attributes ||= {}
        end

        def mandatory_attributes
          @mandatory_attributes ||= []
        end

        def path
          File.join('app', 'models', model_file_name)
        end

        def model_file_name
          "#{file_name}.rb"
        end
      end
    end
  end
end
