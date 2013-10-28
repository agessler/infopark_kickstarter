module Cms
  module Generators
    module Component
      module Tracking
        class GoogleAnalyticsGenerator < ::Rails::Generators::Base
          source_root File.expand_path('../templates', __FILE__)

          def copy_app_directory
            directory('app', force: true)
          end

          def insert_google_analytics
            file = 'app/views/layouts/application.html.haml'
            insert_point = "    = javascript_include_tag('editing') if inplace_editing_allowed?"

            data = []

            data << "\n"
            data << "    = render_cell(:google_analytics, :javascript, 'UA-xxxxxx-x', true)"

            data = data.join("\n")

            insert_into_file(file, data, after: insert_point)
          end
        end
      end
    end
  end
end
