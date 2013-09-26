module Cms
  module Generators
    module Api
      class EditViewGenerator < ::Rails::Generators::Base
        Rails::Generators.hide_namespace(self.namespace)

        source_root File.expand_path('../templates', __FILE__)

        attr_accessor :definitions
        attr_accessor :path
        attr_accessor :object_variable

        def initialize(options = {}, config = {})
          yield self if block_given?

          super([], options, config)

          self.invoke_all
        end

        def create_edit_view
          template('edit.html.haml', "#{path}/edit.html.haml")
        end

        private

        def definitions
          @definitions.inject([]) do |definitions, definition|
            unless widget?(definition)
              definition[:object_variable] = object_variable
              definitions << definition
            end

            definitions
          end
        end

        def widget?(definition)
          definition[:type] == :widget
        end

        def edit_field(definition)
          name = definition[:name]
          type = definition[:type]
          object_variable = definition[:object_variable]

          "= cms_edit_#{type}(#{object_variable}, :#{name})"
        end

        def label(definition)
          name = definition[:name]
          object_variable = definition[:object_variable]

          "= cms_edit_label(#{object_variable}, :#{name})"
        end
      end
    end
  end
end
