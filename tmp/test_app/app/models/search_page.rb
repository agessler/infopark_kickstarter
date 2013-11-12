class SearchPage < Obj
  cms_attribute :show_in_navigation, type: :boolean
  cms_attribute :headline, type: :string

  include Page
end
