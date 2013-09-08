module Cms
  module Generators
    module Widget
      module Column
        class ExampleGenerator < Cms::Generators::Widget::Example::Base
          include Migration

          source_root File.expand_path('../../templates', __FILE__)

          class_option :columns,
            type: :numeric,
            default: 2,
            desc: 'Number of columns'

          def create_example
            example_migration_template(obj_class_name.underscore)
          end

          notice!

          private

          def columns
            options[:columns]
          end

          def obj_class_name
            "Column#{columns}Widget"
          end
        end
      end
    end
  end
end
