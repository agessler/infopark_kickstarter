module Cms
  module Generators
    module Component
      class SocialSharingGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def copy_app_directory
          directory('app', force: true)
        end
      end
    end
  end
end
