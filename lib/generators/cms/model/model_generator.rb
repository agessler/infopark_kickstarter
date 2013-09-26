module Cms
  module Generators
    class ModelGenerator < ::Rails::Generators::NamedBase
      include Migration

      source_root File.expand_path('../templates', __FILE__)

      class_option :title,
        type: :string,
        desc: 'Model title'

      class_option :description,
        type: :string,
        desc: 'Model description'

      class_option :type,
        type: :string,
        aliases: '-t',
        default: 'publication',
        desc: 'Type (publication | generic | document)'

      class_option :attributes,
        type: :hash,
        aliases: '-a',
        default: {},
        desc: 'Attributes and their types'

      class_option :preset_attributes,
        type: :hash,
        aliases: '-p',
        default: {},
        desc: 'Attributes and their defaults'

      class_option :mandatory_attributes,
        type: :array,
        aliases: '-m',
        default: [],
        desc: 'List of mandatory attributes'

      class_option :thumbnail,
        type: :boolean,
        default: true,
        desc: 'Generate thumbnail for obj class browser'

      class_option :page,
        type: :boolean,
        default: false,
        desc: 'Turn the model into a page object'

      class_option :icon,
        type: :string,
        default: 'box',
        desc: 'Icon CSS class name'

      def create
        Api::ObjClassGenerator.new(options, behavior: behavior) do |model|
          model.name = name
          model.title = title
          model.description = description
          model.type = type
          model.icon = icon
          model.attributes = attributes
          model.preset_attributes = preset_attributes
          model.mandatory_attributes = mandatory_attributes
          model.thumbnail = thumbnail?
          model.page = page?
        end
      end

      private

      def thumbnail?
        options[:thumbnail]
      end

      def page?
        options[:page]
      end

      def type
        options[:type]
      end

      def icon
        options[:icon]
      end

      def title
        options[:title] || human_name
      end

      def description
        options[:description] || title
      end

      def attributes
        options[:attributes].inject([]) do |list, (name, type)|
          list << {name: name, type: type}
        end
      end

      def preset_attributes
        options[:preset_attributes]
      end

      def mandatory_attributes
        options[:mandatory_attributes]
      end
    end
  end
end
