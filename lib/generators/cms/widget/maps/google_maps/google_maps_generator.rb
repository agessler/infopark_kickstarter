module Cms
  module Generators
    module Widget
      module Maps
        class GoogleMapsGenerator < ::Rails::Generators::Base
          Rails::Generators.hide_namespace(self.namespace)

          source_root File.expand_path('../templates', __FILE__)

          def create_migration
            Api::WidgetGenerator.new(behavior: behavior) do |widget|
              widget.name = obj_class_name
              widget.icon = 'map'
              widget.description = 'Integrates a map that displays a pin for a given address.'
              widget.attributes = [
                {
                  name: 'address',
                  type: :string,
                  title: 'Address',
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
            'GoogleMapsWidget'
          end
        end
      end
    end
  end
end
