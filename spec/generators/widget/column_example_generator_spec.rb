require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/widget/column/example/example_generator.rb'

describe Cms::Generators::Widget::Column::ExampleGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)
  arguments ['--columns=3', '--max_columns=9']

  before do
    prepare_destination
    run_generator
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'widgets' do
          directory 'column3_widget' do
            directory 'migrate' do
              migration 'create_column3_widget_example'
            end
          end
        end
      end
    }
  end
end
