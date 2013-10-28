class Homepage < Obj
  cms_attribute :headline, type: :string
  cms_attribute :main_content, type: :widget
  cms_attribute :show_in_navigation, type: :boolean
  cms_attribute :sort_key, type: :string
  cms_attribute :error_not_found_page_link, type: :linklist
  cms_attribute :locale, type: :string

  include Page

  # TODO edit mapping from hostnames to homepages
  def self.for_hostname(hostname)
    find_by_path('/website/en')
  end

  # TODO edit mapping from homepages to hostnames
  # Inverse of .for_hostname
  def desired_hostname
    'www.website.com'
  end

  def homepage
    self
  end

  def website
    parent
  end

  # Overriden method +title+ from +Page+.
  def title
    read_attribute('title').presence
  end

  def error_not_found_page
    error_not_found_page_link.first.obj
  end
end
