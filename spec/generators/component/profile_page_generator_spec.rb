require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/component/profile_page/profile_page_generator.rb'

describe Cms::Generators::Component::ProfilePageGenerator do
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
        directory 'models' do
          file 'profile_page.rb' do
            contains 'cms_attribute :sort_key, type: :string'
            contains 'cms_attribute :show_in_navigation, type: :boolean'
            contains 'cms_attribute :headline, type: :string'
            contains 'cms_attribute :content, type: :html'
          end
        end

        directory 'presenters' do
          file 'profile_page_presenter.rb'
        end

        directory 'controllers' do
          file 'profile_page_controller.rb'
        end
      end

      directory 'config' do
        directory 'locales' do
          file 'en.profile_page.yml'
        end
      end

      directory 'cms' do
        directory 'migrate' do
          migration 'create_profile_page'
        end
      end
    }
  end
end
