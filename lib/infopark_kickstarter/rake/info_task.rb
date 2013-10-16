require 'rake'
require 'rake/tasklib'
require 'launchy'
require 'net/http'
require 'json'

module InfoparkKickstarter
  module Rake
    class InfoTask < ::Rake::TaskLib
      def initialize
        desc 'Turn configuration variables into travis secure environment variables'

        task travis_encrypt: :environment do
          travis_encrypt
        end

        namespace :infopark do
          desc 'Open the Infopark console in your web browser'
          task :console do
            Launchy.open('https://console.infopark.net')
          end

          desc 'Get status information of all Infopark services'
          task :status do
            status
          end

          namespace :info do
            desc 'Get information about all object classes in the given workspace (default "published")'
            task :obj_classes, [:workspace] => :environment do |_, args|
              args.with_defaults(workspace: 'published')

              puts obj_class_information(args[:workspace]).to_yaml
            end

            desc 'Get information about all permalinks in the given workspace (default "published")'
            task :permalinks, [:workspace] => :environment do |_, args|
              args.with_defaults(workspace: 'published')

              puts permalinks(args[:workspace]).to_yaml
            end

            desc 'Gathers important system information'
            task system: :environment do
              system_info
            end
          end
        end
      end

      private

      def travis_encrypt
        unless %x{which travis}.present?
          puts 'Please make sure to install the travis command line client with
            `gem install travis` and then run the rake task again.'

          return
        end

        configuration = {
          'CONTENT_SERVICE_URL' => RailsConnector::Configuration.content_service_url,
          'CONTENT_SERVICE_LOGIN' => RailsConnector::Configuration.content_service_login,
          'CONTENT_SERVICE_API_KEY' => RailsConnector::Configuration.content_service_api_key,
          'CMS_URL' => RailsConnector::Configuration.cms_url,
          'CMS_LOGIN' => RailsConnector::Configuration.cms_login,
          'CMS_API_KEY' => RailsConnector::Configuration.cms_api_key,
          'CRM_URL' => Infopark::Crm::Configuration.url,
          'CRM_LOGIN' => Infopark::Crm::Configuration.login,
          'CRM_API_KEY' => Infopark::Crm::Configuration.api_key,
        }

        contributor = %x(whoami).strip

        puts "Please add the following to your .travis.yml file:\n\n"
        puts "# #{contributor}'s credentials"

        Bundler.with_clean_env do
          configuration.map do |key, value|
            token = %x{travis encrypt #{key}=#{value}}

            puts "- secure: #{token}"
          end
        end
      end

      def system_info
        output = []

        output << ''
        output << 'System Component Versions'
        output << '-------------------------'

        %w(ruby gem rvm rbenv git).each do |name|
          output << "#{name}: #{command_version_for(name)}"
        end

        %w(
          rails
          infopark_kickstarter
          infopark_rails_connector
          infopark_cloud_connector
          infopark_crm_connector
        ).each do |name|
          output << "#{name}: #{gem_version_for(name)}"
        end

        output << ''
        output << 'Object Class Definitions'
        output << '------------------------'
        output << obj_class_information('published').to_yaml

        output = output.join("\n")

        path = Rails.root + "tmp/infopark-support-#{Time.now.to_i}.txt"

        File.open(path, 'w+') do |file|
          file.write(output)
        end

        puts output
      end

      def command_version_for(name)
        unless %x{which #{name}}.empty?
          %x{#{name} --version}.strip
        end
      end

      def gem_version_for(name)
        Gem::Specification.find_by_name(name).version.to_s
      rescue Gem::LoadError
        'not found'
      end

      def obj_class_information(workspace)
        RailsConnector::Workspace.find(workspace).as_current do
          obj_classes.inject({}) do |attributes, obj_class|
            attributes[obj_class.name] = attribute_names(obj_class)

            attributes
          end
        end
      end

      def attribute_names(obj_class)
        obj_class.attributes.map(&:name).join(', ').presence
      end

      def obj_classes
        InfoparkKickstarter::ObjClass.all
      end

      def permalinks(workspace)
        RailsConnector::Workspace.find(workspace).as_current do
          objs = Obj.
            where(:_permalink, :is_greater_than, ' ').
            order(:_permalink).
            to_a

          objs.inject({}) do |permalinks, obj|
            permalinks[obj[:_permalink]] = obj[:_path]

            permalinks
          end
        end
      end

      def status
        uri = URI('http://status.infopark.net/services.json')
        response = Net::HTTP.get(uri)
        json = JSON.parse(response)

        service_status = {
          'Platform' => 'up and running',
          'CMS' => 'up and running',
          'WebCRM' => 'up and running',
        }

        now = Time.now.strftime("%Y-%m-%d")

        if json.has_key?(now)
          json[now].each do |service, info|
            service_status[service] = info['description']
          end
        end

        service_status.each do |service, status|
          puts "  #{service}: #{status}"
        end
      end
    end
  end
end
