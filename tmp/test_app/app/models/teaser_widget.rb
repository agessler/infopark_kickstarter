class TeaserWidget < Widget
  cms_attribute :headline, type: :string
  cms_attribute :content, type: :html
  cms_attribute :link_to, type: :linklist, max_size: 1
end
