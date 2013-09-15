require 'spec_helper'

require 'generator_spec/test_case'
require 'rails/generators/test_case'
require 'generators/cms/widget/video/video_generator.rb'

describe Cms::Generators::Widget::VideoGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)
  arguments ['--example']

  before do
    prepare_destination
    prepare_environments
    run_generator
  end

  def prepare_environments
    javascripts_path = "#{destination_root}/app/assets/javascripts"
    stylesheets_path = "#{destination_root}/app/assets/stylesheets"

    mkdir_p(javascripts_path)
    mkdir_p(stylesheets_path)

    File.open("#{javascripts_path}/application.js", 'w') { |file| file.write("//= require infopark_rails_connector\n") }
    File.open("#{stylesheets_path}/application.css", 'w') { |file| file.write("*= require infopark_rails_connector\n") }
    File.open("#{destination_root}/Gemfile", 'w')
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'cells' do
          directory 'widget' do
            file 'video_widget_cell.rb'

            directory 'video_widget' do
              file 'show.html.haml'
              file 'projekktor.html.haml'
              file 'youtube.html.haml'
              file 'vimeo.html.haml'
            end
          end
        end

        directory 'assets' do
          directory 'javascripts' do
            file 'application.js' do
              contains '//= require projekktor'
              contains '//= require projekktor.config'
            end

            file 'projekktor.config.js.coffee' do
              contains 'controls: true'
            end
          end

          directory 'stylesheets' do
            file 'application.css' do
              contains '*= require projekktor'
            end
          end
        end

        directory 'widgets' do
          directory 'video_widget' do
            directory 'views' do
              file 'show.html.haml'
              file 'thumbnail.html.haml'
            end

            directory 'locales' do
              file 'en.video_widget.yml'
            end

            directory 'migrate' do
              migration 'create_video_widget'
            end
          end
        end

        directory 'models' do
          file 'video_widget.rb' do
            contains 'cms_attribute :source, type: :linklist, max_size: 1'
            contains 'cms_attribute :width, type: :integer'
            contains 'cms_attribute :height, type: :integer'
            contains 'cms_attribute :autoplay, type: :boolean'
            contains 'cms_attribute :poster, type: :linklist, max_size: 1'
            contains 'include Widget'
          end
        end
      end

      file 'Gemfile' do
        contains 'gem "video_info"'
        contains 'gem "projekktor-rails"'
      end
    }
  end
end
