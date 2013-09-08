module Cms
  module Generators
    module Widget
      class ApiGenerator < ::Rails::Generators::NamedBase
        include BasePaths
        include Actions

        Rails::Generators.hide_namespace(self.namespace)

        source_root File.expand_path('../templates', __FILE__)

        attr_accessor :name
        attr_accessor :icon
        attr_accessor :title
        attr_accessor :description
        attr_accessor :attributes
        attr_accessor :preset_attributes
        attr_accessor :mandatory_attributes

        def initialize(config = {})
          yield self if block_given?

          super([name], {}, config)

          self.invoke_all
        end

        def create
          Model::ApiGenerator.new(behavior: behavior) do |model|
            model.name = name
            model.title = title
            model.description = description
            model.type = :publication
            model.migration_path = "#{widget_path}/migrate"
            model.model_path = model_path
            model.thumbnail = false
            model.widget = true
            model.attributes = attributes
            model.preset_attributes = preset_attributes
            model.mandatory_attributes = mandatory_attributes
          end

          template('en.locale.yml', "#{widget_path}/locales/en.#{file_name}.yml")
          template('edit.html.haml', "#{widget_path}/views/edit.html.haml")
          template('show.html.haml', "#{widget_path}/views/show.html.haml")
          template('thumbnail.html.haml', "#{widget_path}/views/thumbnail.html.haml")
        end

        private

        def icon
          @icon ||= 'puzzle'
        end

        def title
          @title ||= human_name
        end

        def description
          @description ||= ''
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

        def model_path
          'app/models'
        end

        def widget_path
          widget_path_for(file_name)
        end
      end
    end
  end
end
