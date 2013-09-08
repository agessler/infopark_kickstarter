module Cms
  module Generators
    module Component
      module Editing
        class RedactorGenerator < ::Rails::Generators::Base
          Rails::Generators.hide_namespace(self.namespace)

          source_root File.expand_path('../templates', __FILE__)

          def create_files
            directory('app')
            directory('vendor')
          end

          def update_application_css
            file = 'app/assets/stylesheets/application.css'
            insert_point = '*= require infopark_rails_connector'

            data = []
            data << ''
            data << ' *= require redactor'

            data = data.join("\n")

            insert_into_file(file, data, after: insert_point)
          end

          def update_application_js
            file = 'app/assets/javascripts/application.js'
            insert_point = "//= require infopark_rails_connector"

            data = []

            data << ''
            data << '//= require redactor'
            data << '//= require redactor.config'

            data = data.join("\n")

            insert_into_file(file, data, after: insert_point)
          end
        end
      end
    end
  end
end
