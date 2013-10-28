require 'uri'

module Cms
  module Generators
    class KickstartGenerator < ::Rails::Generators::Base
      include Migration
      include BasePaths

      class_option :examples,
        type: :boolean,
        default: false,
        desc: 'Creates example content along with setting up your project.'

      source_root File.expand_path('../templates', __FILE__)

      def remove_index_html
        path = Rails.root + 'public/index.html'

        if File.exist?(path)
          remove_file(path)
        end
      end

      def remove_rails_image
        path = Rails.root + 'app/assets/images/rails.png'

        if File.exist?(path)
          remove_file(path)
        end
      end

      def install_gems
        gem('active_attr')
        gem('haml-rails')
        gem('cells')
        gem('utf8-cleaner')
        gem('infopark_crm_connector')

        gem_group(:assets) do
          gem('less-rails-bootstrap', '~> 2.3')
        end

        Bundler.with_clean_env do
          run('bundle --quiet')
        end
      end

      def remove_erb_layout
        path = Rails.root + 'app/views/layouts/application.html.erb'

        if File.exist?(path)
          remove_file(path)
        end
      end

      def update_rails_configuration
        gsub_file(
          'config/application.rb',
          "# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]",
          "config.i18n.load_path += Dir[Rails.root + 'app/widgets/**/locales/*']"
        )

        log(:info, 'enable widget locales')
      end

      def update_application_configuration
        directory('lib')
        directory('config', force: true)
      end

      def extend_gitignore
        append_file('.gitignore', "config/rails_connector.yml\n")
        append_file('.gitignore', "config/custom_cloud.yml\n")
      end

      # TODO: remove special migration once the CMS tenant is properly reset after signup. This
      # should also allow to remove the "migration" variable on Api::ObjClassGenerator.
      def create_special_case_image
        Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
          model.name = 'Image'
          model.type = :generic
          model.title = 'Image'
          model.thumbnail = false
          model.migration = false
        end

        migration_template('create_image.rb', 'cms/migrate/create_image')
      end

      def create_structure_migration_file
        Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
          model.name = 'Video'
          model.type = :generic
          model.title = 'Video'
          model.thumbnail = false
          model.attributes = [
            title_attribute,
          ]
        end

        class_name = 'Homepage'

        Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
          model.name = class_name
          model.title = 'Homepage'
          model.thumbnail = false
          model.attributes = [
            title_attribute,
            main_content_attribute,
            show_in_navigation_attribute,
            sort_key_attribute,
            {
              name: 'error_not_found_page',
              type: :reference,
              title: 'Error Not Found Page',
            },
            {
              name: 'locale',
              type: :string,
              title: 'Locale',
            },
          ]
        end

        Rails::Generators.invoke('cms:controller', [class_name], behavior: behavior)

        Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
          model.name = 'Root'
          model.title = 'Root'
          model.thumbnail = false
        end

        Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
          model.name = 'Website'
          model.title = 'Website'
          model.thumbnail = false
        end

        Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
          model.name = 'Container'
          model.title = 'Container'
          model.thumbnail = false
          model.attributes = [
            title_attribute,
            show_in_navigation_attribute,
          ]
        end

        Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
          model.name = 'ResourceContainer'
          model.title = 'Resouce Container'
          model.thumbnail = false
          model.attributes = [
            title_attribute,
            show_in_navigation_attribute,
          ]
        end

        class_name = 'ContentPage'

        Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
          model.name = class_name
          model.title = 'Content'
          model.page = true
          model.attributes = [
            title_attribute,
            show_in_navigation_attribute,
            sort_key_attribute,
            main_content_attribute,
            sidebar_content_attribute
          ]
        end

        Rails::Generators.invoke('cms:controller', [class_name], behavior: behavior)

        class_name = 'ErrorPage'

        Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
          model.name = class_name
          model.title = 'Error'
          model.thumbnail = false
          model.page = true
          model.attributes = [
            title_attribute,
            content_attribute,
            show_in_navigation_attribute,
          ]
        end

        Rails::Generators.invoke('cms:controller', [class_name], behavior: behavior)

        migration_template('create_structure.rb', 'cms/migrate/create_structure.rb')
      end

      def override_application
        directory('app', force: true)
      end

      def add_initial_content
        Rails::Generators.invoke('cms:component:editing', ['--editor=redactor'], behavior: behavior)
        Rails::Generators.invoke('cms:component:developer_tools', [], behavior: behavior)
        Rails::Generators.invoke('cms:component:search', [], behavior: behavior)
        Rails::Generators.invoke('cms:component:login_page', [], behavior: behavior)
        Rails::Generators.invoke('cms:component:sitemap', [], behavior: behavior)

        unless examples?
          Rails::Generators.invoke('cms:widget:text', [], behavior: behavior)
          Rails::Generators.invoke('cms:widget:image', [], behavior: behavior)
          Rails::Generators.invoke('cms:widget:headline', [], behavior: behavior)
        end
      end

      def create_example_content
        if examples?
          Rails::Generators.invoke('cms:kickstart:example', [], behavior: behavior)
        end
      end

      private

      def examples?
        options[:examples]
      end

      def show_in_navigation_attribute
        {
          name: 'show_in_navigation',
          type: :boolean,
          title: 'Show in Navigation',
        }
      end

      def sort_key_attribute
        {
          name: 'sort_key',
          type: :string,
          title: 'Sort key',
        }
      end

      def main_content_attribute
        {
          name: 'main_content',
          type: :widget,
          title: 'Main content',
        }
      end

      def sidebar_content_attribute
        {
          name: 'sidebar_content',
          type: :widget,
          title: 'Sidebar content',
        }
      end

      def title_attribute
        {
          name: 'headline',
          type: :string,
          title: 'Headline',
        }
      end

      def content_attribute
        {
          name: 'content',
          type: :html,
          title: 'Content',
        }
      end
    end
  end
end
