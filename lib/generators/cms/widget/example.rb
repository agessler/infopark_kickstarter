module Cms
  module Generators
    module Widget
      module Example
        class Base < ::Rails::Generators::Base
          include BasePaths
          include BaseAttributes
          include Migration

          class_option :cms_path,
            type: :string,
            desc: 'CMS parent path where the example should be placed under'

          class_option :attribute,
            type: :string,
            desc: 'Widget attribute of the object class that holds the widget'

          def self.notice!
            define_method(:notice) do
              if behavior == :invoke
                log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes')
              end
            end
          end

          protected

          def example_cms_path
            options[:cms_path] || homepage_path
          end

          def example_cms_path?
            example_cms_path
          end

          def example_widget_attribute
            options[:attribute] || homepage_widget_attribute
          end

          def example_widget_attribute?
            example_widget_attribute
          end

          def example_migration_template(migration_name)
            path = "#{widget_path_for(migration_name)}/migrate"

            migration_template(
              'example_migration.rb',
              "#{path}/create_#{migration_name}_example.rb"
            )
          end
        end
      end
    end
  end
end
