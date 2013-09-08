module Cms
  module Generators
    module Widget
      class PersonGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def create_migration
          Widget::ApiGenerator.new(behavior: behavior) do |widget|
            widget.name = obj_class_name
            widget.icon = 'person'
            widget.description = 'Displays a WebCRM person and shows their details.'
            widget.attributes = [
              {
                name: 'person',
                type: :string,
                title: 'Person identifier',
              },
            ]
          end

          directory('app', force: true)
        end

        def notice
          if behavior == :invoke
            log(:migration, 'Make sure to run "rake cms:migrate" to apply CMS changes.')
          end
        end

        private

        def obj_class_name
          'PersonWidget'
        end
      end
    end
  end
end
