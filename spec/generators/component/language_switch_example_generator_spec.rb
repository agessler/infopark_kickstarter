require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/component/language_switch/example/example_generator.rb'

describe Cms::Generators::Component::LanguageSwitch::ExampleGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)

  before do
    prepare_destination
    prepare_environments
    run_generator
  end

  def prepare_environments
    layouts_path = "#{destination_root}/app/views/layouts"

    mkdir_p(layouts_path)

    File.open("#{layouts_path}/application.html.haml", 'w') { |f| f.write("            = render_cell(:meta_navigation, :show, @obj, current_user)\n") }
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'views' do
          directory 'layouts' do
            file 'application.html.haml' do
              contains '= render_cell(:language_switch, :show, @obj.homepages, @obj.homepage)'
            end
          end
        end
      end
    }
  end
end
