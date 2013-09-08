require 'rake'
require 'rake/tasklib'

require 'infopark_kickstarter/rake/configuration_helper'

module InfoparkKickstarter
  module Rake
    class IntegrationTask < ::Rake::TaskLib
      def initialize
        namespace :test do
          desc 'Run Kickstarter Integration Tests'

          task :integration do
            create_application
            create_configuration_files

            cd(app_path) do
              Bundler.with_clean_env do
                bundle
                call_generators
                reset_cms
                migrate
                run_tests
              end
            end
          end
        end
      end

      private

      def create_application
        rm_rf(app_path)

        sh("rails new #{app_path} --skip-test-unit --skip-active-record --skip-bundle --template template.rb")
      end

      def create_configuration_files
        path = Pathname.new(app_path) + 'config'
        ConfigurationHelper.new(path).copy
      end

      def bundle
        sh('bundle --quiet')
      end

      def reset_cms
        sh('bundle exec rake cms:reset[true]')
      end

      def call_generators
        generators = [
          'cms:kickstart --examples',
          'cms:component:testing',
          'cms:component:redirect',
          'cms:component:error_tracking --provider=airbrake',
          'cms:component:error_tracking --provider=honeybadger',
          'cms:component:monitoring "Test Website" --provider=newrelic',
          'cms:component:tracking --provider=google_analytics',
          'cms:component:language_switch',
          'cms:component:language_switch:example',
          'cms:component:form_builder --cms_path=/website/en',
          'cms:component:social_sharing',
          'cms:component:social_sharing:example',
          'cms:component:breadcrumbs',
          'cms:widget:video',
          'cms:widget:video:example',
          'cms:widget:person',
          'cms:widget:person:example',
          'cms:widget:slider',
          'cms:widget:slider:example',
          'cms:widget:login',
          'cms:widget:login:example',
          'cms:widget:slideshare',
          'cms:widget:slideshare:example',
          'cms:widget:column --columns=2',
          'cms:widget:column:example --columns=2',
          'cms:widget:column --columns=3',
          'cms:widget:column:example --columns=3',
        ]

        generators.each do |generator|
          sh("bundle exec rails generate #{generator}")
        end
      end

      def migrate
        sh('bundle exec rake cms:migrate')
      end

      def run_tests
        sh('bundle exec rake spec')
      end

      def app_path
        File.expand_path('../../../../tmp/test_app', __FILE__)
      end
    end
  end
end
