module Cms
  module Generators
    module Api
      class ObjClassGenerator < ::Rails::Generators::NamedBase
        Rails::Generators.hide_namespace(self.namespace)

        include Attributes
        include Migration

        source_root File.expand_path('../templates', __FILE__)

        attr_accessor :title
        attr_accessor :description
        attr_accessor :type
        attr_accessor :attributes
        attr_accessor :preset_attributes
        attr_accessor :mandatory_attributes
        attr_accessor :page
        attr_accessor :widget
        attr_accessor :thumbnail
        attr_accessor :icon
        attr_accessor :migration

        def initialize(options = {}, config = {})
          yield self if block_given?

          super([name], options, config)

          self.invoke_all
        end

        def create_model
          Api::ModelGenerator.new(behavior: behavior) do |model|
            model.name = name
            model.attributes = attributes
            model.preset_attributes = preset_attributes
            model.mandatory_attributes = mandatory_attributes
            model.page = page
            model.widget = widget
          end
        end

        def create_migration
          if migration?
            transform_attributes!(attributes, preset_attributes)

            migration_template('migration.rb', "cms/migrate/create_#{file_name}.rb")
          end
        end

        def create_edit_view
          Api::EditViewGenerator.new(behavior: behavior) do |model|
            model.path = "app/views/#{file_name}"
            model.definitions = attributes
            model.object_variable = '@obj'
          end
        end

        def create_thumbnail
          if thumbnail?
            Api::ThumbnailGenerator.new(behavior: behavior) do |thumbnail|
              thumbnail.name = name
              thumbnail.path = "app/views/#{file_name}"
              thumbnail.icon = icon
              thumbnail.title_key = "obj_classes.#{file_name}.title"
              thumbnail.description_key = "obj_classes.#{file_name}.description"
            end
          end
        end

        def add_locale
          if thumbnail?
            Api::LocaleGenerator.new(behavior: behavior) do |locale|
              locale.name = name
              locale.path = 'config/locales/en.obj_classes.yml'
              locale.translations = {
                'en' => {
                  'obj_classes' => {
                    file_name => {
                      'title' => title,
                      'description' => description,
                    },
                  },
                },
              }
            end
          end
        end

        private

        def type
          @type ||= :publication
        end

        def migration?
          @migration.nil? ? true : @migration
        end

        def thumbnail?
          @thumbnail.nil? ? true : @thumbnail
        end

        def icon
          @icon ||= 'box'
        end

        def attributes
          @attributes ||= []
        end

        def preset_attributes
          @preset_attributes ||= {}
        end
      end
    end
  end
end
