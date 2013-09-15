require 'spec_helper'

require 'generator_spec/test_case'
require 'rails/generators/test_case'
require 'generators/cms/widget/teaser/teaser_generator.rb'

describe Cms::Generators::Widget::TeaserGenerator do
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
          directory 'teaser_widget' do
            directory 'views' do
              file 'show.html.haml'
              file 'thumbnail.html.haml'
            end

            directory 'locales' do
              file 'en.teaser_widget.yml'
            end

            directory 'migrate' do
              migration 'create_teaser_widget'
            end
          end
        end

        directory 'models' do
          file 'teaser_widget.rb' do
            contains 'cms_attribute :content, type: :html'
            contains 'cms_attribute :headline, type: :string'
            contains 'cms_attribute :link_to, type: :linklist, max_size: 1'
            contains 'include Widget'
          end
        end
      end
    }
  end
end
