module Cms
  module Generators
    module Component
      class ProfilePageGenerator < ::Rails::Generators::Base
        include Migration
        include BasePaths

        source_root File.expand_path('../templates', __FILE__)

        def create_migration
          Model::ApiGenerator.new(behavior: behavior) do |model|
            model.name = obj_class_name
            model.title = 'Page: Profile'
            model.page = true
            model.attributes = [
              {
                name: 'headline',
                type: :string,
                title: 'Headline',
              },
              {
                name: 'content',
                type: :html,
                title: 'Content',
              },
              {
                name: show_in_navigation_attribute_name,
                type: :boolean,
                title: 'Show in navigation',
              },
              {
                name: sort_key_attribute_name,
                type: :string,
                title: 'Sort key',
              },
            ]
          end
        end

        def copy_app_directory
          directory('app', force: true)
          directory('config', force: true)
        end

        def notice
          if behavior == :invoke
            log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes.')
          end
        end

        private

        def show_in_navigation_attribute_name
          'show_in_navigation'
        end

        def sort_key_attribute_name
          'sort_key'
        end

        def obj_class_name
          'ProfilePage'
        end
      end
    end
  end
end
