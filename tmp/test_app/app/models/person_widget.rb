class PersonWidget < Widget
  cms_attribute :person, type: :string

  # Overrides auto-generated method +person+ from +CmsAttributes+.
  def person
    person = self[:person] || ''

    if person.present?
      @person ||= Infopark::Crm::Contact.search(params: { login: person }).first
      @person ||= Infopark::Crm::Contact.search(params: { email: person }).first
    end
  end
end
