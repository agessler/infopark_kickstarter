require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/widget/headline/headline_generator.rb'

describe Cms::Generators::Widget::HeadlineGenerator do
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
          directory 'headline_widget' do
            directory 'locales' do
              file 'en.headline_widget.yml'
            end

            directory 'migrate' do
              migration 'create_headline_widget'
            end

            directory 'views' do
              file 'show.html.haml'
              file 'thumbnail.html.haml'
            end
          end
        end

        directory 'models' do
          file 'headline_widget.rb' do
            contains 'cms_attribute :headline, type: :string'
            contains 'include Widget'
          end
        end
      end
    }
  end
end
