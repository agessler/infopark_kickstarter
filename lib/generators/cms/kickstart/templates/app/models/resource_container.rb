class Container < Obj
  cms_attribute :headline, type: :string
  cms_attribute :show_in_navigation, type: :boolean

  def page
    parent.page
  end
end
