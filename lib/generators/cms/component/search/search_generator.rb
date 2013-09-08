module Cms
  module Generators
    module Component
      class SearchGenerator < ::Rails::Generators::Base
        include Migration
        include BasePaths
        include Actions

        class_option :homepage_path,
          type: :string,
          default: nil,
          desc: 'Path to a CMS homepage, for which to enable search.'

        source_root File.expand_path('../templates', __FILE__)

        def extend_homepage
          add_model_attribute('Homepage', search_page_attribute)
        end

        def extend_view
          file = 'app/cells/main_navigation/show.html.haml'
          insert_point = "    .container\n"

          data = []

          data << "      = render_cell(:search, :form, @page, params[:q])\n"
          data << ''

          data = data.join("\n")

          insert_into_file(file, data, after: insert_point)
        end

        def create_migration
          class_name = 'SearchPage'

          Model::ApiGenerator.new(behavior: behavior) do |model|
            model.name = class_name
            model.title = 'Page: Search'
            model.thumbnail = false
            model.page = true
            model.attributes = [
              {
                name: show_in_navigation_attribute_name,
                type: :boolean,
                title: 'Show in navigation',
              },
              {
                name: headline_attribute_name,
                type: :string,
                title: 'Headline',
              },
            ]
          end

          Rails::Generators.invoke('cms:controller', [class_name])

          migration_template('example_migration.rb', 'cms/migrate/create_search_page_example.rb')
        end

        def copy_app_directory
          directory('app', force: true)
          directory('config', force: true)
          directory('spec', force: true)
        end

        def notice
          if behavior == :invoke
            log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes.')
          end
        end

        private

        alias_method :original_homepage_path, :homepage_path
        def homepage_path
          options[:homepage_path] || original_homepage_path
        end

        def show_in_navigation_attribute_name
          'show_in_navigation'
        end

        def headline_attribute_name
          'headline'
        end

        def search_page_attribute
          {
            name: 'search_page_link',
            type: :linklist,
            title: 'Search Page',
            max_size: 1,
          }
        end

        def class_name
          'SearchPage'
        end
      end
    end
  end
end
