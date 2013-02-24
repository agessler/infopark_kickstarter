require 'generators/cms/migration'

module Cms
  module Generators
    module Widget
      class TextGenerator < ::Rails::Generators::Base
        include Migration

        class_option :cms_path,
          type: :string,
          default: nil,
          desc: 'CMS parent path where the example widget should be placed.',
          banner: 'LOCATION'

        source_root File.expand_path('../templates', __FILE__)

        def create_migration
          begin
            validate_attribute(sort_key_attribute_name)
            Rails::Generators.invoke('cms:attribute', [sort_key_attribute_name, '--type=string', '--title=Sort Key'])
          rescue Cms::Generators::DuplicateResourceError
          end

          begin
            validate_obj_class(obj_class_name)
            Rails::Generators.invoke('cms:model', ['BoxText', '--title=Box: Text', "--attributes=#{sort_key_attribute_name}"])
          rescue Cms::Generators::DuplicateResourceError
          end

          if behavior == :invoke
            log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes')
          end
        end

        def adopt_model
          gsub_file(
            'app/models/box_text.rb',
            'include Page',
            'include Box'
          )
        end

        def copy_app_directory
          directory('app')
        end

        def add_example
          if example?
            migration_template('example_migration.rb', 'cms/migrate/create_text_widget_example.rb')
          end
        end

        private

        def example?
          cms_path.present?
        end

        def cms_path
          options[:cms_path]
        end

        def obj_class_name
          'BoxText'
        end

        def sort_key_attribute_name
          'sort_key'
        end
      end
    end
  end
end