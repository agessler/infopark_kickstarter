module Cms
  module Generators
    module Component
      module SocialSharing
        class ExampleGenerator < ::Rails::Generators::Base
          def insert_share_code
            file = 'app/views/layouts/application.html.haml'
            insert_point = "      = render_cell(:footer, :show, @obj)"

            data = []

            data << "      = render_cell(:social_sharing, :show, cms_url(@obj))"
            data << "\n"

            data = data.join("\n")

            insert_into_file(file, data, before: insert_point)
          end
        end
      end
    end
  end
end
