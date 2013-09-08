module Cms
  module Generators
    module Widget
      class ImageGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def create_widget
          Widget::ApiGenerator.new(behavior: behavior) do |widget|
            widget.name = obj_class_name
            widget.icon = 'image'
            widget.description = 'Widget that holds an image.'
            widget.attributes = [
              {
                name: 'source',
                type: :linklist,
                title: 'Source',
                max_size: 1,
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
          'ImageWidget'
        end
      end
    end
  end
end
