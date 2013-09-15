module Cms
  module Generators
    module Kickstart
      class ExampleGenerator < ::Rails::Generators::Base
        def create_examples
          Rails::Generators.invoke('cms:widget:teaser')
          Rails::Generators.invoke('cms:widget:teaser:example')

          Rails::Generators.invoke('cms:widget:image')
          Rails::Generators.invoke('cms:widget:image:example')

          Rails::Generators.invoke('cms:widget:headline')
          Rails::Generators.invoke('cms:widget:headline:example')

          Rails::Generators.invoke('cms:widget:maps')
          Rails::Generators.invoke('cms:widget:maps:example')

          Rails::Generators.invoke('cms:widget:text')
          Rails::Generators.invoke('cms:widget:text:example')

          Rails::Generators.invoke('cms:component:profile_page')
          Rails::Generators.invoke('cms:component:profile_page:example', ['/website/en'])

          Rails::Generators.invoke('cms:component:contact_page')
          Rails::Generators.invoke('cms:component:contact_page:example', ['/website/en'])

          Rails::Generators.invoke('cms:component:blog')
          Rails::Generators.invoke('cms:component:blog:example', ['/website/en'])
        end
      end
    end
  end
end
