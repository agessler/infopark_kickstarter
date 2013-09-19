require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/api/locale/locale_generator'

describe Cms::Generators::Api::LocaleGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)

  before do
    prepare_destination

    Cms::Generators::Api::LocaleGenerator.new do |config|
      config.name = 'foo'
      config.path = 'config/locales/en.foo.yml'
      config.translations = {
        'en' => {
          'test' => {
            'foo' => {
              'title' => 'Foo',
              'description' => 'Bar',
            },
          },
        },
      }
    end
  end

  it 'generates locale' do
    destination_root.should have_structure {
      directory 'config' do
        directory 'locales' do
          file 'en.foo.yml' do
            contains 'en:'
            contains '  test:'
            contains '    foo:'
            contains '      title: Foo'
            contains '      description: Bar'
          end
        end
      end
    }
  end
end
