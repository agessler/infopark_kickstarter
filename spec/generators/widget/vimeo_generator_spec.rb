require 'spec_helper'

require 'generator_spec/test_case'
require 'rails/generators/test_case'
require 'generators/cms/widget/vimeo/vimeo_generator.rb'

describe Cms::Generators::Widget::VimeoGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)
  arguments ['--example']

  before do
    prepare_destination
    run_generator
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'widgets' do
          directory 'vimeo_widget' do
            directory 'views' do
              file 'show.html.haml'
              file 'thumbnail.html.haml'
            end

            directory 'locales' do
              file 'en.vimeo_widget.yml'
            end

            directory 'migrate' do
              migration 'create_vimeo_widget'
            end
          end
        end

        directory 'models' do
          file 'vimeo_widget.rb' do
            contains 'class VimeoWidget < Widget'
            contains 'cms_attribute :source, type: :linklist, max_size: 1'
            contains 'cms_attribute :width, type: :integer'
            contains 'cms_attribute :height, type: :integer'
          end
        end
      end
    }
  end
end
