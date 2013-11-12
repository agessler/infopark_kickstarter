class ContentPage < Obj
  cms_attribute :headline, type: :string
  cms_attribute :show_in_navigation, type: :boolean
  cms_attribute :sort_key, type: :string
  cms_attribute :main_content, type: :widget
  cms_attribute :sidebar_content, type: :widget

  include Page
end
