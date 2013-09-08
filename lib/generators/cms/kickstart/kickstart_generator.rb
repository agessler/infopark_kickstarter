require 'uri'

module Cms
  module Generators
    class KickstartGenerator < ::Rails::Generators::Base
      include Migration
      include BasePaths

      class_option :configuration_path,
        type: :string,
        default: nil,
        desc: 'Path to a JSON configuration file.'

      class_option :examples,
        type: :boolean,
        default: false,
        desc: 'Creates example content along with setting up your project.'

      source_root File.expand_path('../templates', __FILE__)

      def initialize(args = [], options = {}, config = {})
        options << '--force'

        super(args, options, config)
      end

      def read_config_file
        path = options[:configuration_path]

        if path
          contents = if URI(path).is_a?(URI::HTTP)
            open(path, 'Accept' => 'application/json') { |io| io.read }
          else
            File.read(path)
          end

          configuration = JSON(contents)

          configuration.each do |generator|
            name = generator['name']
            options = Array(generator['options'])

            Rails::Generators.invoke(name, options, behavior: behavior)
          end
        end
      end

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

      def append_asset_manifests
        append_file('app/assets/javascripts/application.js', '//= require infopark_rails_connector')
        gsub_file('app/assets/stylesheets/application.css', '*= require_tree .', "*= require_tree .\n *= require infopark_rails_connector")
      end

      def install_gems
        gem('active_attr')
        gem('simple_form')
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

      def form_tools
        generate('simple_form:install --bootstrap --template-engine=haml')

        remove_file('config/locales/simple_form.de.yml')
        remove_file('config/locales/simple_form.en.yml')
        remove_dir('lib/templates')
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

      def create_structure_migration_file
        Model::ApiGenerator.new(behavior: behavior) do |model|
          model.name = 'Image'
          model.type = :generic
          model.title = 'Resource: Image'
          model.thumbnail = false
        end

        Model::ApiGenerator.new(behavior: behavior) do |model|
          model.name = 'Video'
          model.type = :generic
          model.title = 'Resource: Video'
          model.thumbnail = false
          model.attributes = [
            title_attribute,
          ]
        end

        class_name = 'Homepage'

        Model::ApiGenerator.new(behavior: behavior) do |model|
          model.name = class_name
          model.title = 'Page: Homepage'
          model.thumbnail = false
          model.attributes = [
            title_attribute,
            main_content_attribute,
            show_in_navigation_attribute,
            sort_key_attribute,
            {
              name: 'error_not_found_page_link',
              type: :linklist,
              title: 'Error Not Found Page',
              max_size: 1,
            },
            {
              name: 'locale',
              type: :string,
              title: 'Locale',
            },
          ]
        end

        Rails::Generators.invoke('cms:controller', [class_name])

        Model::ApiGenerator.new(behavior: behavior) do |model|
          model.name = 'Root'
          model.title = 'Root'
          model.thumbnail = false
        end

        Model::ApiGenerator.new(behavior: behavior) do |model|
          model.name = 'Website'
          model.title = 'Website'
          model.thumbnail = false
        end

        Model::ApiGenerator.new(behavior: behavior) do |model|
          model.name = 'Container'
          model.title = 'Container'
          model.thumbnail = false
          model.attributes = [
            title_attribute,
            show_in_navigation_attribute,
          ]
        end

        class_name = 'ContentPage'

        Model::ApiGenerator.new(behavior: behavior) do |model|
          model.name = class_name
          model.title = 'Page: Content'
          model.page = true
          model.attributes = [
            title_attribute,
            show_in_navigation_attribute,
            sort_key_attribute,
            main_content_attribute,
            sidebar_content_attribute
          ]
        end

        Rails::Generators.invoke('cms:controller', [class_name])

        class_name = 'ErrorPage'

        Model::ApiGenerator.new(behavior: behavior) do |model|
          model.name = class_name
          model.title = 'Page: Error'
          model.thumbnail = false
          model.page = true
          model.attributes = [
            title_attribute,
            content_attribute,
            show_in_navigation_attribute,
          ]
        end

        Rails::Generators.invoke('cms:controller', [class_name])

        migration_template('create_structure.rb', 'cms/migrate/create_structure.rb')
      end

      def override_application
        directory('app', force: true)
      end

      def add_initial_content
        Rails::Generators.invoke('cms:component:editing', ['--editor=redactor'])
        Rails::Generators.invoke('cms:component:developer_tools')
        Rails::Generators.invoke('cms:component:search')
        Rails::Generators.invoke('cms:component:login_page')
        Rails::Generators.invoke('cms:component:sitemap')

        unless examples?
          Rails::Generators.invoke('cms:widget:text')
          Rails::Generators.invoke('cms:widget:image')
          Rails::Generators.invoke('cms:widget:headline')
        end
      end

      def create_example_content
        if examples?
          Rails::Generators.invoke('cms:kickstart:example')
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
