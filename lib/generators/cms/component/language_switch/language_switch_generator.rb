module Cms
  module Generators
    module Component
      class LanguageSwitchGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def copy_app_directory
          directory('app')
          directory('config')
        end
      end
    end
  end
end
