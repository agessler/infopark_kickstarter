module Cms
  module Generators
    module Component
      module ProfilePage
        class ExampleGenerator < ::Rails::Generators::Base
          include Migration

          source_root File.expand_path('../../templates', __FILE__)

          argument :cms_path,
            type: :string,
            default: nil,
            desc: 'CMS parent path where the example profile should be placed under.',
            banner: 'LOCATION'

          def create_example
            migration_template('example_migration.rb', 'cms/migrate/create_profile_page_example.rb')
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
end
