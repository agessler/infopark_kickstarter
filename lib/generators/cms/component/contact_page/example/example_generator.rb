require_relative '../contact_page_description'

module Cms
  module Generators
    module Component
      module ContactPage
        class ExampleGenerator < ::Rails::Generators::Base
          include Migration

          argument :cms_path,
            type: :string,
            default: nil,
            desc: 'CMS parent path where the example contact page should be placed under.'

          source_root File.expand_path('../../templates', __FILE__)


          def create_example
            migration_template('example_migration.rb', 'cms/migrate/create_contact_page_example.rb')
          end

          private

          def class_name
            'ContactPage'
          end

          include ContactPageDescription
        end
      end
    end
  end
end
