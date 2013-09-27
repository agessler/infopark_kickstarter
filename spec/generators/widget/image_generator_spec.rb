require 'spec_helper'

require 'generator_spec/test_case'
require 'rails/generators/test_case'
require 'generators/cms/widget/image/image_generator.rb'

describe Cms::Generators::Widget::ImageGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)

  before do
    prepare_destination
    prepare_environments
    run_generator
  end

  def prepare_environments
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'widgets' do
          directory 'image_widget' do
            directory 'views' do
              file 'show.html.haml'
              file 'thumbnail.html.haml'
            end

            directory 'locales' do
              file 'en.image_widget.yml'
            end

            directory 'migrate' do
              migration 'create_image_widget'
            end
          end
        end

        directory 'models' do
          file 'image_widget.rb' do
            contains 'cms_attribute :source, type: :reference'
            contains 'include Widget'
          end
        end
      end
    }
  end
end
