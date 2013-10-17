module Cms
  module Generators
    module Widget
      class VimeoGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def create_migration
          Api::WidgetGenerator.new(options, behavior: behavior) do |widget|
            widget.name = obj_class_name
            widget.icon = 'video'
            widget.description = 'Displays a vimeo video player for the given vimeo link.'
            widget.attributes = [
              {
                name: 'source',
                type: :linklist,
                title: 'Source',
                max_size: 1,
              },
              {
                name: 'width',
                type: :integer,
                title: 'Width',
                default: 660,
              },
              {
                name: 'height',
                type: :string,
                title: 'Height',
                default: 430,
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
          'VimeoWidget'
        end
      end
    end
  end
end
