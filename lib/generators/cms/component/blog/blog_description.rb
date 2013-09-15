module Cms
  module Generators
    module Component
      module BlogDescription
        def blog_class_name
          'Blog'
        end

        def blog_post_class_name
          'BlogPost'
        end

        def widget_attribute_name
          'main_content'
        end

        def blog_description_attribute_name
          'description'
        end

        def blog_post_author_attribute_name
          'author'
        end

        def blog_post_abstract_attribute_name
          'abstract'
        end

        def blog_disqus_shortname_attribute_name
          'disqus_shortname'
        end
      end
    end
  end
end
