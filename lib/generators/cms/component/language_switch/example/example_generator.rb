module Cms
  module Generators
    module Component
      module LanguageSwitch
        class ExampleGenerator < ::Rails::Generators::Base
          source_root File.expand_path('../../templates', __FILE__)

          def extend_homepage
            file = 'app/views/layouts/application.html.haml'
            insert_point = "            = render_cell(:meta_navigation, :show, @obj, current_user)\n"

            data = []

            data << ''
            data << '            = render_cell(:language_switch, :show, @obj.homepages, @obj.homepage)'
            data << ''

            data = data.join("\n")

            insert_into_file(file, data, after: insert_point)
          end
        end
      end
    end
  end
end
