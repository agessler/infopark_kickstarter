module Cms
  module Generators
    module Widget
      module Maps
        module GoogleMaps
          class ExampleGenerator < Cms::Generators::Widget::Example::Base
            include Migration

            Rails::Generators.hide_namespace(self.namespace)

            source_root File.expand_path('../../templates', __FILE__)

            def create_example
              example_migration_template(obj_class_name.underscore)
            end

            notice!

            private

            def obj_class_name
              'GoogleMapsWidget'
            end
          end
        end
      end
    end
  end
end
