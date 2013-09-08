module Cms
  module Generators
    module Component
      class FormBuilderGenerator < ::Rails::Generators::Base
        include Migration

        source_root File.expand_path('../templates', __FILE__)

        class_option :cms_path,
          type: :string,
          default: nil,
          desc: 'CMS parent path where the example form should be placed under.',
          banner: 'LOCATION'

        def create_migration
          Model::ApiGenerator.new(behavior: behavior) do |model|
            model.name = class_name
            model.title = 'Page: FormBuilder'
            model.page = true
            model.attributes = [
              {
                name: title_attribute_name,
                type: :string,
                title: 'Headline',
              },
              {
                name: body_attribute_name,
                type: :html,
                title: 'Content',
              },
              {
                name: crm_activity_type_attribute_name,
                type: :string,
                title: 'CRM Activity Type',
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

        def create_example
          if example?
            migration_template('example_migration.rb', 'cms/migrate/create_form_builder_example.rb')
          end
        end

        def copy_app_directory
          directory('app', force: true)
          directory('config', force: true)
        end

        def notice
          if behavior == :invoke
            log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes')
          end
        end

        private

        def example?
          cms_path.present?
        end

        def cms_path
          options[:cms_path]
        end

        def class_name
          'FormBuilder'
        end

        def crm_activity_type_attribute_name
          'crm_activity_type'
        end

        def show_in_navigation_attribute_name
          'show_in_navigation'
        end

        def sort_key_attribute_name
          'sort_key'
        end

        def activity_type
          'feedback-form'
        end

        def title_attribute_name
          'headline'
        end

        def body_attribute_name
          'content'
        end
      end
    end
  end
end
