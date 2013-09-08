module Cms
  module Generators
    module Widget
      class TextGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def create_widget
          Widget::ApiGenerator.new(behavior: behavior) do |widget|
            widget.name = obj_class_name
            widget.icon = 'text'
            widget.description = 'Creates a simple widget with content.'
            widget.attributes = [
              {
                name: 'content',
                type: :html,
                title: 'Content',
              },
            ]
          end

          directory('app', force: true)
        end

        def notice
          if behavior == :invoke
            log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes')
          end
        end

        private

        def obj_class_name
          'TextWidget'
        end
      end
    end
  end
end
