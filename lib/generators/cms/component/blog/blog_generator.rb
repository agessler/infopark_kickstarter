require_relative 'blog_description'

module Cms
  module Generators
    module Component
      class BlogGenerator < ::Rails::Generators::Base
        include Migration

        source_root File.expand_path('../templates', __FILE__)

        def add_gems
          gem('gravatar_image_tag')

          Bundler.with_clean_env do
            run('bundle --quiet')
          end
        end

        def create_migration
          Model::ApiGenerator.new(behavior: behavior) do |model|
            model.name = blog_class_name
            model.title = 'Page: Blog'
            model.page = true
            model.attributes = [
              {
                name: 'headline',
                type: :string,
                title: 'Headline',
              },
              {
                name: blog_disqus_shortname_attribute_name,
                type: :string,
                title: 'Disqus Shortname',
              },
              {
                name: blog_description_attribute_name,
                type: :text,
                title: 'Description',
              },
            ]
          end

          Model::ApiGenerator.new(behavior: behavior) do |model|
            model.name = blog_post_class_name
            model.title = 'Page: Blog Post'
            model.thumbnail = false
            model.page = true
            model.attributes = [
              {
                name: 'headline',
                type: :string,
                title: 'Headline',
              },
              {
                name: blog_post_author_attribute_name,
                type: :string,
                title: 'Author',
              },
              {
                name: widget_attribute_name,
                type: :widget,
                title: 'Main content',
              },
              {
                name: blog_post_abstract_attribute_name,
                type: :html,
                title: 'Abstract',
              },
            ]
          end

          Rails::Generators.invoke('cms:controller', [blog_post_class_name])
        end

        def add_discovery_link
          file = 'app/views/layouts/application.html.haml'
          insert_point = "%link{href: '/favicon.ico', rel: 'shortcut icon'}\n"

          data = []

          data << ''
          data << '    = render_cell(:blog, :discovery, @obj)'
          data << ''

          data = data.join("\n")

          insert_into_file(file, data, after: insert_point)
        end

        def copy_app_directory
          directory('app', force: true)
          directory('config')
        end

        def notice
          if behavior == :invoke
            log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes')
          end
        end

        private

        include BlogDescription
      end
    end
  end
end
