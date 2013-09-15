require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/component/social_sharing/example/example_generator.rb'

describe Cms::Generators::Component::SocialSharing::ExampleGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)

  before do
    prepare_destination
    prepare_environments
    run_generator
  end

  def prepare_environments
    environments_path = "#{destination_root}/app/views/layouts"

    mkdir_p(environments_path)

    File.open("#{environments_path}/application.html.haml", 'w') { |file| file.write('      = render_cell(:footer, :show, @obj)') }
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'views' do
          directory 'layouts' do
            file 'application.html.haml' do
              contains '= render_cell(:social_sharing, :show, cms_url(@obj))'
            end
          end
        end
      end
    }
  end
end
