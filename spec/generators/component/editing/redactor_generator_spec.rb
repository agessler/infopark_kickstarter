require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/component/editing/redactor/redactor_generator'

describe Cms::Generators::Component::Editing::RedactorGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../../tmp/generators', __FILE__)

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
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'assets' do
          directory 'fonts' do
            file 'redactor_icons.eot'
            file 'redactor_icons.ttf'
            file 'redactor_icons.woff'
          end

          directory 'stylesheets' do
            file 'redactor.css.less'
            file 'application.css' do
              contains '*= require redactor'
            end
          end

          directory 'javascripts' do
            file 'redactor.config.js.coffee'

            file 'application.js' do
              contains '//= require redactor'
              contains '//= require redactor.config'
            end
          end
        end
      end

      directory 'vendor' do
        directory 'assets' do
          directory 'javascripts' do
            file 'redactor.js'
          end
        end
      end
    }
  end
end
