module Cms
  module Generators
    module Migration
      def self.included(base)
        base.send(:include, ::Rails::Generators::Migration)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods
        def next_migration_number(dirname)
          migration_paths = Dir.glob([
            Rails.root + 'cms/migrate',
            Rails.root + 'app/widgets/**/migrate/',
          ])

          ids = migration_paths.inject([]) do |ids, dirname|
            ids << current_migration_number(dirname)
          end

          timestamp = [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d"].max.to_i
          max = ids.max.to_i

          while max >= timestamp do
            timestamp += 1
          end

          timestamp
        end
      end
    end
  end
end
