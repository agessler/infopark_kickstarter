module Cms
  module Generators
    module Actions
      def turn_model_into_page(class_name, model_path = 'app/models')
        file_name = "#{class_name.underscore}.rb"

        gsub_file(
          "#{model_path}/#{file_name}",
          '# include Page',
          'include Page'
        )
      end

      def turn_model_into_widget(class_name, model_path = 'app/models')
        file_name = "#{class_name.underscore}.rb"

        gsub_file(
          "#{model_path}/#{file_name}",
          '# include Widget',
          'include Widget'
        )
      end

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

        insert_into_file(file, data, :after => insert_point)
      end
    end
  end
end