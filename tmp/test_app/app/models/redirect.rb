class Redirect < Obj
  cms_attribute :show_in_navigation, type: :boolean
  cms_attribute :sort_key, type: :string
  cms_attribute :redirect_link, type: :linklist, max_size: 1

  include Page
end
