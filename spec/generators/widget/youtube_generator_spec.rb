require 'spec_helper'

require 'generator_spec/test_case'
require 'rails/generators/test_case'
require 'generators/cms/widget/youtube/youtube_generator.rb'

describe Cms::Generators::Widget::YoutubeGenerator do
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
          directory 'youtube_widget' do
            directory 'views' do
              file 'show.html.haml'
              file 'thumbnail.html.haml'
            end

            directory 'locales' do
              file 'en.youtube_widget.yml'
            end

            directory 'migrate' do
              migration 'create_youtube_widget'
            end
          end
        end

        directory 'models' do
          file 'youtube_widget.rb' do
            contains 'class YoutubeWidget < Widget'
            contains 'cms_attribute :source, type: :linklist, max_size: 1'
            contains 'cms_attribute :max_width, type: :integer'
            contains 'cms_attribute :max_height, type: :integer'
          end
        end
      end
    }
  end
end
