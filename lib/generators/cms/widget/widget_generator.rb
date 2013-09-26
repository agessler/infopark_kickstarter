module Cms
  module Generators
    class WidgetGenerator < ::Rails::Generators::NamedBase
      class_option :title,
        type: :string,
        desc: 'Widget title displayed in widget browser.'

      class_option :description,
        type: :string,
        desc: 'Widget description displayed in widget browser.'

      class_option :icon,
        type: :string,
        desc: 'Widget icon displayed in widget browser.'

      class_option :attributes,
        type: :hash,
        aliases: '-a',
        default: {},
        desc: 'Description of attributes and their type.'

      class_option :preset_attributes,
        type: :hash,
        aliases: '-p',
        default: {},
        desc: 'Description of attributes and their defaults.'

      class_option :mandatory_attributes,
        type: :array,
        aliases: '-m',
        default: [],
        desc: 'List of mandatory attributes.'

      def create_widget
        Api::WidgetGenerator.new(options, behavior: behavior) do |widget|
          widget.name = class_name
          widget.title = title
          widget.description = description
          widget.icon = icon
          widget.attributes = attributes
          widget.preset_attributes = preset_attributes
          widget.mandatory_attributes = mandatory_attributes
        end
      end

      private

      def icon
        options[:icon]
      end

      def title
        options[:title] || human_name
      end

      def description
        options[:description] || ''
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
