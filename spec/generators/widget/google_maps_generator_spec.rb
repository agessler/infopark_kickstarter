require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/widget/maps/google_maps/google_maps_generator.rb'

describe Cms::Generators::Widget::Maps::GoogleMapsGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)

  before do
    prepare_destination
    run_generator
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'assets' do
          directory 'stylesheets' do
            directory 'application' do
              file 'google_maps_widget.css.less'
            end
          end
        end

        directory 'widgets' do
          directory 'google_maps_widget' do
            directory 'locales' do
              file 'en.google_maps_widget.yml'
            end

            directory 'migrate' do
              migration 'create_google_maps_widget'
            end

            directory 'views' do
              file 'show.html.haml'
              file 'thumbnail.html.haml'
            end
          end
        end

        directory 'models' do
          file 'google_maps_widget.rb' do
            contains 'class GoogleMapsWidget < Widget'
            contains 'cms_attribute :address, type: :string'
          end
        end
      end
    }
  end
end
