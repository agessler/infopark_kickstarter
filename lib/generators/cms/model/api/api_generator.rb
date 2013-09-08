module Cms
  module Generators
    module Model
      class ApiGenerator < ::Rails::Generators::NamedBase
        Rails::Generators.hide_namespace(self.namespace)
        include Migration
        include Actions

        source_root File.expand_path('../templates', __FILE__)

        attr_accessor :name
        attr_accessor :title
        attr_accessor :description
        attr_accessor :type
        attr_accessor :attributes
        attr_accessor :preset_attributes
        attr_accessor :mandatory_attributes
        attr_accessor :migration_path
        attr_accessor :model_path
        attr_accessor :thumbnail
        attr_accessor :page
        attr_accessor :widget

        def initialize(config = {})
          yield self if block_given?

          super([name], {}, config)

          self.invoke_all
        end

        def create_model_file
          template('model.rb', File.join(model_path, "#{file_name}.rb"))
        end

        def create_model_thumbnail
          if thumbnail?
            template('thumbnail.html.haml', File.join('app/views/', file_name, 'thumbnail.html.haml'))
          end
        end

        def add_locales
          unless widget?
            locale_path = Pathname.new(File.join(destination_root, 'config/locales/en.obj_classes.yml'))

            unless File.exist?(locale_path)
              FileUtils.mkdir_p(locale_path.dirname)

              File.open(locale_path, 'w') do |file|
                file.write("en:\n  obj_classes:\n")
              end
            end

            append_file(
              locale_path,
              "    #{file_name}:\n      title: '#{title}'\n      description: '#{description}'\n"
            )
          end
        end

        def handle_attributes
          attributes.each do |definition|
            name = definition[:name]
            type = definition[:type]
            default = definition.delete(:default)

            if default.present?
              preset_attributes[name] = default
            end

            case type.to_s
              when 'boolean'
                definition[:type] = :enum
                definition[:values] = ['Yes', 'No']
              when 'integer'
                definition[:type] = :string
            end
          end
        end

        def create_migration_file
          migration_template('migration.rb', "#{migration_path}/create_#{file_name}.rb")
        end

        def turn_into_page
          if page?
            file_name = "#{class_name.underscore}.rb"

            gsub_file(
              "#{model_path}/#{file_name}",
              '# include Page',
              'include Page'
            )
          end
        end

        def turn_into_widget
          if widget?
            file_name = "#{class_name.underscore}.rb"

            gsub_file(
              "#{model_path}/#{file_name}",
              '# include Widget',
              'include Widget'
            )
          end
        end

        private

        def page?
          @page.nil? ? false : @page
        end

        def widget?
          @widget.nil? ? false : @widget
        end

        def thumbnail?
          @thumbnail.nil? ? true : @thumbnail
        end

        def type
          @type ||= :publication
        end

        def title
          @title ||= human_name
        end

        def description
          @description ||= title
        end

        def attributes
          @attributes ||= []
        end

        def preset_attributes
          @preset_attributes ||= {}
        end

        def mandatory_attributes
          @mandatory_attributes ||= []
        end

        def migration_path
          @migration_path ||= 'cms/migrate'
        end

        def model_path
          @model_path ||= 'app/models'
        end
      end
    end
  end
end
