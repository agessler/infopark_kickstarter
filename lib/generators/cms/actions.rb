module Cms
  module Generators
    module Actions
      def generate_attribute_method(attribute)
        method = "cms_attribute :#{attribute[:name]}, type: :#{attribute[:type]}"

        if attribute[:default].present?
          method.concat(", default: '#{attribute[:default]}'")
        end

        if attribute[:values].present?
          method.concat(", values: #{attribute[:values].inspect}")
        end

        if attribute[:max_size].present?
          method.concat(", max_size: #{attribute[:max_size]}")
        end

        if attribute[:min_size].present?
          method.concat(", min_size: #{attribute[:min_size]}")
        end

        method
      end

      def add_model_attribute(model, attribute, model_path = 'app/models')
        file = "#{model_path}/#{model.underscore}.rb"
        insert_point = "class #{model} < Obj\n"

        data = []

        data << "  #{generate_attribute_method(attribute)}"
        data << ''

        data = data.join("\n")

        insert_into_file(file, data, after: insert_point)
      end

      def update_javascript_manifest(data)
        file = 'app/assets/javascripts/application.js'
        insert_point = "\n//= require_self"

        insert_into_file(file, data, before: insert_point)
      end

      def update_javascript_editing_manifest(data)
        file = 'app/assets/javascripts/editing.js'
        insert_point = "\n//= require_self"

        insert_into_file(file, data, before: insert_point)
      end

      def update_stylesheet_manifest(data)
        file = 'app/assets/stylesheets/application.css'
        insert_point = "\n *= require_self"

        insert_into_file(file, data, before: insert_point)
      end

      def update_stylesheet_editing_manifest(data)
        file = 'app/assets/stylesheets/editing.css'
        insert_point = "\n *= require_self"

        insert_into_file(file, data, before: insert_point)
      end
    end
  end
end
