require 'spec_helper'

require 'generator_spec/test_case'
require 'rails/generators/test_case'
require 'generators/cms/widget/login/login_generator.rb'

describe Cms::Generators::Widget::LoginGenerator do
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
        directory 'cells' do
          directory 'widget' do
            file 'login_widget_cell.rb'

            directory 'login_widget' do
              file 'show.html.haml'
              file 'form.html.haml'
              file 'logout.html.haml'
              file 'reset_password.html.haml'
            end
          end
        end

        directory 'widgets' do
          directory 'login_widget' do
            directory 'views' do
              file 'show.html.haml'
              file 'thumbnail.html.haml'
            end

            directory 'locales' do
              file 'en.login_widget.yml'
            end

            directory 'migrate' do
              migration 'create_login_widget'
            end
          end
        end

        directory 'models' do
          file 'login_widget.rb' do
            contains 'include Widget'
          end
        end
      end
    }
  end
end
