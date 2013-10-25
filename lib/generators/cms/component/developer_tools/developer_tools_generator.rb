module Cms
  module Generators
    module Component
      class DeveloperToolsGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def install_gems
          gem_group(:test, :development) do
            gem('pry-rails')
            gem('rails-footnotes')
            gem('thin')
            gem('infopark_dashboard', '>= 0.0.2')
          end

          gem_group(:development) do
            gem('better_errors')
            gem('binding_of_caller')
          end

          Bundler.with_clean_env do
            run('bundle --quiet')
          end
        end

        def add_dashboard_route
          route('mount InfoparkDashboard::Engine => "/cms/dashboard" if Rails.env.development?')
        end

        def copy_app_directory
          directory('lib')
          directory('config', force: true)
        end

        def notice
          if behavior == :invoke
            log(:server, 'Please make sure to restart your server, because of gem changes.')
          end
        end
      end
    end
  end
end
