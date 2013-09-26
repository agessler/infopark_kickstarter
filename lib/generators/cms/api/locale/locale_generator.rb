module Cms
  module Generators
    module Api
      class LocaleGenerator < ::Rails::Generators::NamedBase
        Rails::Generators.hide_namespace(self.namespace)

        source_root File.expand_path('../templates', __FILE__)

        attr_accessor :path
        attr_accessor :translations

        def initialize(options = {}, config = {})
          yield self if block_given?

          super([name], options, config)

          self.invoke_all
        end

        def create_locale_file
          unless File.exist?(full_path)
            FileUtils.mkdir_p(full_path.dirname)

            File.open(full_path, 'w') do |file|
              file.write(nil.to_yaml)
            end
          end
        end

        def insert_translations
          translations = YAML.load_file(full_path) || {}

          translations.deep_merge!(@translations)

          File.write(full_path, translations.to_yaml)
        end

        private

        def full_path
          Pathname.new(File.join(destination_root, path))
        end
      end
    end
  end
end
