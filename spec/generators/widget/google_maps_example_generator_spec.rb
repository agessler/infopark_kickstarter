require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/widget/maps/google_maps/example/example_generator.rb'

describe Cms::Generators::Widget::Maps::GoogleMaps::ExampleGenerator do
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
          directory 'google_maps_widget' do
            directory 'migrate' do
              migration 'create_google_maps_widget_example'
            end
          end
        end
      end
    }
  end
end
