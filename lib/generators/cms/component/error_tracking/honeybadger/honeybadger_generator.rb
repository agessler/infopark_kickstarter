module Cms
  module Generators
    module Component
      module ErrorTracking
        class HoneybadgerGenerator < ::Rails::Generators::Base
          Rails::Generators.hide_namespace(self.namespace)

          source_root File.expand_path('../templates', __FILE__)

          class_option :skip_deployment_notification,
            type: :boolean,
            default: false,
            desc: 'Skip to notify honeybadger on new deployments.'

          def include_gemfile
            gem('honeybadger')

            Bundler.with_clean_env do
              run('bundle --quiet')
            end
          end

          def create_initializer_file
            template('honeybadger.rb', 'config/initializers/honeybadger.rb')
          end

          def update_local_custom_cloud_file
            path = File.join(destination_root, 'config/custom_cloud.yml')

            if File.exist?(path)
              append_file(path) do
                File.read(find_in_source_paths('custom_cloud.yml'))
              end
            end
          end

          def add_deployment_notification
            unless options[:skip_deployment_notification]
              destination = 'deploy/after_restart.rb'

              unless File.exist?(destination)
                create_file(destination)
              end

              append_file(destination) do
                File.read(find_in_source_paths('after_restart.rb'))
              end
            end
          end

          def display_notice
            if behavior == :invoke
              log(:config,
                'Please add your Honeybadger API key to the section ' +
                '"honeybadger" in "config/custom_cloud.yml".'
              )
            end
          end
        end
      end
    end
  end
end
