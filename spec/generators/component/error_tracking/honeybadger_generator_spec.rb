require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/component/error_tracking/honeybadger/honeybadger_generator'

describe Cms::Generators::Component::ErrorTracking::HoneybadgerGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../../tmp/generators', __FILE__)

  before do
    prepare_destination
    prepare_environments
    run_generator
  end

  def prepare_environments
    config_path = "#{destination_root}/config"
    initializers_path = "#{config_path}/initializers"

    mkdir_p(initializers_path)

    File.open("#{destination_root}/Gemfile", 'w')
    File.open("#{config_path}/custom_cloud.yml", 'w')
  end

  it 'creates initializer file' do
    destination_root.should have_structure {
      directory 'config' do
        file 'custom_cloud.yml' do
          contains 'honeybadger:'
          contains "  api_key: ''"
        end

        directory 'initializers' do
          file 'honeybadger.rb' do
            contains "config.api_key = ENV['HONEYBADGER_API_KEY'] || honeybadger_config['api_key']"
          end
        end
      end

      directory 'deploy' do
        file 'after_restart.rb' do
          contains 'run "bundle exec rake honeybadger:deploy REPO=#{repository} TO=#{new_resource.environment[\'RAILS_ENV\']} USER=#{user} REVISION=#{revision}"'
        end
      end

      file 'Gemfile' do
        contains 'gem "honeybadger"'
      end
    }
  end
end
