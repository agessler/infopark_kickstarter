module Cms
  module Generators
    module Component
      module Editing
        class RedactorGenerator < ::Rails::Generators::Base
          include Cms::Generators::Actions

          Rails::Generators.hide_namespace(self.namespace)

          source_root File.expand_path('../templates', __FILE__)

          def create_files
            directory('app')
            directory('vendor')
          end

          def update_application_js
            data = []

            data << ''
            data << '//= require redactor'

            data = data.join("\n")

            update_javascript_editing_manifest(data)
          end
        end
      end
    end
  end
end
