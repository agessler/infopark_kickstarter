require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/component/form_builder/form_builder_generator.rb'

describe Cms::Generators::Component::FormBuilderGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)

  arguments ['--cms_path=/website/en']

  before do
    prepare_destination
    run_generator
  end

  it 'creates file' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'models' do
          file 'form_builder.rb' do
            contains 'cms_attribute :headline, type: :string'
            contains 'cms_attribute :content, type: :html'
            contains 'cms_attribute :sort_key, type: :string'
            contains 'cms_attribute :show_in_navigation, type: :boolean'
            contains 'cms_attribute :crm_activity_type, type: :string'
          end
        end

        directory 'cells' do
          file 'form_builder_cell.rb'

          directory 'form_builder' do
            file 'show.html.haml'
            file 'string.html.haml'
            file 'text.html.haml'
            file 'enum.html.haml'
            file 'multienum.html.haml'
          end
        end

        directory 'presenters' do
          file 'form_presenter.rb'
        end

        directory 'services' do
          file 'activity_service.rb'
        end
      end

      directory 'config' do
        directory 'locales' do
          file 'en.form_builder.yml'
        end
      end

      directory 'cms' do
        directory 'migrate' do
          migration 'create_form_builder'
          migration 'create_form_builder_example'
        end
      end
    }
  end
end
