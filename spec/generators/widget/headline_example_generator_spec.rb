require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/widget/headline/example/example_generator.rb'

describe Cms::Generators::Widget::Headline::ExampleGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)

  before do
    prepare_destination
    run_generator
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'widgets' do
          directory 'headline_widget' do
            directory 'migrate' do
              migration 'create_headline_widget_example'
            end
          end
        end
      end
    }
  end
end
