module Cms
  module Generators
    module Component
      class RedirectGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def create_migration
          class_name = 'Redirect'

          Model::ApiGenerator.new(behavior: behavior) do |model|
            model.name = class_name
            model.title = 'Redirect'
            model.page = true
            model.attributes = [
              {
                name: 'show_in_navigation',
                type: :boolean,
                title: 'Show in Navigation',
              },
              {
                name: 'sort_key',
                type: :string,
                title: 'Sort key',
              },
              {
                name: 'redirect_link',
                type: :linklist,
                title: 'Redirect link',
                max_size: 1,
              },
            ]
          end
        end

        def copy_app_directory
          directory('app', force: true)
          directory('config')
        end
      end
    end
  end
end
