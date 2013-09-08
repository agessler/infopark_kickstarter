require_relative '../blog_description'

module Cms
  module Generators
    module Component
      module Blog
        class ExampleGenerator < ::Rails::Generators::Base
          include Migration

          source_root File.expand_path('../../templates', __FILE__)


          argument :cms_path,
            type: :string,
            default: nil,
            desc: 'CMS parent path where the example blog should be placed under.',
            banner: 'LOCATION'

          def create_example
            migration_template('example_migration.rb', 'cms/migrate/create_blog_example.rb')
          end

          private

          include BlogDescription
        end
      end
    end
  end
end
