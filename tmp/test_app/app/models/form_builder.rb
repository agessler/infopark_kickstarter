class FormBuilder < Obj
  cms_attribute :headline, type: :string
  cms_attribute :content, type: :html
  cms_attribute :crm_activity_type, type: :string
  cms_attribute :show_in_navigation, type: :boolean
  cms_attribute :sort_key, type: :string

  include Page
end
