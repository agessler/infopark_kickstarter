require 'spec_helper'

require 'generator_spec/test_case'
require 'rails/generators/test_case'
require 'generators/cms/widget/text/text_generator.rb'

describe Cms::Generators::Widget::TextGenerator do
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
          directory 'text_widget' do
            directory 'views' do
              file 'show.html.haml'
              file 'thumbnail.html.haml'
            end

            directory 'locales' do
              file 'en.text_widget.yml'
            end

            directory 'migrate' do
              migration 'create_text_widget'
            end
          end
        end

        directory 'models' do
          file 'text_widget.rb' do
            contains 'cms_attribute :headline, type: :string'
            contains 'cms_attribute :content, type: :html'
            contains 'include Widget'
          end
        end
      end
    }
  end
end