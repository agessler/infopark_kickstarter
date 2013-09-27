module Cms
  module Generators
    module Widget
      class SlideshareGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def create_migration
          Api::WidgetGenerator.new(options, behavior: behavior) do |widget|
            widget.name = obj_class_name
            widget.icon = 'presentation'
            widget.description = 'Creates a widget that shows a slide from slideshare.'
            widget.attributes = [
              {
                name: 'source',
                type: :linklist,
                title: 'Source',
                max_size: 1,
              }
            ]
          end

          directory('app', force: true)
          directory('spec')
        end

        def notice
          if behavior == :invoke
            log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes')
          end
        end

        private

        def obj_class_name
          'SlideshareWidget'
        end
      end
    end
  end
end
