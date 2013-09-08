require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/component/contact_page/example/example_generator'

describe Cms::Generators::Component::ContactPage::ExampleGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)

  arguments ['/website/en']

  before do
    prepare_destination
    prepare_environments
    run_generator
  end

  def prepare_environments
  end

  it 'creates file' do
    destination_root.should have_structure {
      directory 'cms' do
        directory 'migrate' do
          migration 'create_contact_page_example'
        end
      end
    }
  end
end
