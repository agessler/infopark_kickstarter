require './lib/rails_connector/cms_attributes'
require './lib/rails_connector/cms_definitions'

# This class represents the base class of all CMS objects and implements behavior that all CMS
# objects, regardless whether they are pages or resources have in common.
class Obj < ::RailsConnector::BasicObj
  include RailsConnector::CmsAttributes
  include RailsConnector::CmsDefinitions

  def self.homepage
    default_homepage
  end

  def self.default_homepage
    Homepage.for_hostname('default')
  end

  def mediabrowser_edit_view_path
    "#{obj_class.underscore}/edit"
  end

  def parent
    @parent ||= super()
  end

  def ancestors
    @ancestors ||= super()
  end

  # Determines the homepage for the current object by traversing up the tree
  # until a homepage is found. In case of a ghost path (no parent) the default
  # homepage is returned.
  def homepage
    @homepage ||= if parent
      parent.homepage
    else
      self.class.default_homepage
    end
  end

  def homepages
    website.homepages
  end

  def website
    @website ||= homepage.website
  end

  # Overriden method +slug+ from +RailsConnector::BasicObj+.
  def slug
    (self[:headline] || '').parameterize
  end

  # Return a page object or nil.
  #
  # Normally, objects are either pages or resources.
  # Pages are pages in itself. Resources are filtered out.
  #
  # This method can be overridden by subclasses to implement this behaviour.
  def page
    nil
  end

  def locale
    (homepage && homepage.locale) || I18n.default_locale
  end

  def menu_title
    self[:headline] || '[no headline]'
  end

  # By default, objects can be displayed in navigation sections. Either add a
  # boolean cms attribute +show_in_navigation+ or override the method directly
  # in your model.
  def show_in_navigation?
    true
  end

  # By default, objects have no sort_key set. Either add a string cms attribute
  # +sort_key+ or override the method directly in your model.
  def sort_key
    ''
  end

  # Overrides RailsConnector::BasicObj#body_data_url
  #
  # Changes protocol http: to https: so that the URLs work fine with pages delivered over https.
  def body_data_url
    url = super

    if url.to_s =~ /^http:(.*?s3\.amazonaws\.com.*)$/
      "https:#{$1}"
    else
      url
    end
  end
end
