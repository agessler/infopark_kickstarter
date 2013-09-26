module Cms
  module Generators
    module Api
      class ThumbnailGenerator < ::Rails::Generators::NamedBase
        Rails::Generators.hide_namespace(self.namespace)

        source_root File.expand_path('../templates', __FILE__)

        attr_accessor :title_key
        attr_accessor :icon
        attr_accessor :description_key
        attr_accessor :path

        def initialize(options = {}, config = {})
          yield self if block_given?

          super([name], options, config)

          self.invoke_all
        end

        def create_thumbnail
          template('thumbnail.html.haml', File.join(path, 'thumbnail.html.haml'))
        end
      end
    end
  end
end
