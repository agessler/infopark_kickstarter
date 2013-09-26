module Cms
  module Generators
    module Widget
      class HeadlineGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def create_widget
          Api::WidgetGenerator.new(options, behavior: behavior) do |widget|
            widget.name = obj_class_name
            widget.icon = 'headline'
            widget.description = 'The headline widget displays a title on the page.'
            widget.attributes = [
              {
                name: 'headline',
                type: :string,
                title: 'Headline',
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
          'HeadlineWidget'
        end
      end
    end
  end
end
