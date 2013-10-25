require 'rake'
require 'rake/tasklib'
require 'launchy'
require 'net/http'
require 'json'

module InfoparkKickstarter
  module Rake
    class InfoTask < ::Rake::TaskLib
      def initialize
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
