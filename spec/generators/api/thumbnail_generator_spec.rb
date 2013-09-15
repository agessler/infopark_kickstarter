require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/api/thumbnail/thumbnail_generator'

describe Cms::Generators::Api::ThumbnailGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)

  before do
    prepare_destination

    Cms::Generators::Api::ThumbnailGenerator.new do |config|
      config.name = 'foo'
      config.icon = 'foo'
      config.path = 'app/views/foo'
      config.title_key = 'test.foo.foo'
      config.description_key = 'test.bar.bar'
    end
  end

  it 'generates edit view' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'views' do
          directory 'foo' do
            file 'thumbnail.html.haml' do
              contains "%i.thumbnail-icon.editing-icon-foo"
              contains "= t('test.foo.foo')"
              contains "= t('test.bar.bar')"
            end
          end
        end
      end
    }
  end
end
