module Cms
  module Generators
    module Component
      module Editing
        class RedactorGenerator < ::Rails::Generators::Base
          include Actions

          Rails::Generators.hide_namespace(self.namespace)

          source_root File.expand_path('../templates', __FILE__)

          def create_files
            directory('app')
            directory('vendor')
          end

          def update_application_css
            data = []

            data << ''
            data << ' *= require editors/redactor'

            data = data.join("\n")

            update_stylesheet_manifest(data)
          end

          def update_application_js
            data = []

            data << ''
            data << '//= require redactor'
            data << '//= require editors/redactor.config'

            data = data.join("\n")

            update_javascript_manifest(data)
          end
        end
      end
    end
  end
end
