require './lib/rails_connector/cms_attributes'
require './lib/rails_connector/cms_definitions'

# This class represents the base class of all CMS widgets and implements behavior that all CMS
# widgets have in common.
class Widget < ::RailsConnector::BasicWidget
  include RailsConnector::CmsAttributes
  include RailsConnector::CmsDefinitions

  # Determines the page where the widget is embedded.
  def page
    obj
  end

  # Determines the homepage based on the widget page.
  def homepage
    page.homepage
  end
end
