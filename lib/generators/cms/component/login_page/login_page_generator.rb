module Cms
  module Generators
    module Component
      class LoginPageGenerator < ::Rails::Generators::Base
        include Actions
        include Migration
        include BasePaths

        source_root File.expand_path('../templates', __FILE__)

        def create_migration
          Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
            model.name = login_obj_class_name
            model.title = 'Login'
            model.thumbnail = false
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
                name: 'show_in_navigation',
                type: :boolean,
                title: 'Show in Navigation',
              },
              {
                name: 'sort_key',
                type: :string,
                title: 'Sort key',
              },
            ]
          end

          Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
            model.name = reset_password_obj_class_name
            model.title = 'ResetPassword'
            model.thumbnail = false
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
                name: 'show_in_navigation',
                type: :boolean,
                title: 'Show in Navigation',
              },
              {
                name: 'sort_key',
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

        def update_homepage
          migration_template('migration.rb', 'cms/migrate/login_page_example.rb')
        end

        def update_homepage_model
          attribute = {
            name: login_page_link_attribute_name,
            type: :linklist,
            max_size: 1,
          }

          add_model_attribute('Homepage', attribute)

          file = 'app/models/homepage.rb'

          data = [
            "\n",
            '  def login_page',
            '    login_page_link.first.obj',
            '  end',
          ].join("\n")
          insert_point = 'include Page'

          insert_into_file(file, data, after: insert_point)
        end

        def update_footer_cell
          append_file 'app/cells/footer/show.html.haml' do
            [
              "\n",
              '          |',
              '          = render_cell(:login, :show, @page)',
            ].join("\n")
          end
        end

        def notice
          if behavior == :invoke
            log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes.')
          end
        end

        private

        def login_page_link_attribute_name
          'login_page_link'
        end

        def login_obj_class_name
          'LoginPage'
        end

        def reset_password_obj_class_name
          'ResetPasswordPage'
        end
      end
    end
  end
end
