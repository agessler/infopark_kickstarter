def content_service_config
  config = YAML.load_file(Rails.root + 'config/rails_connector.yml')
  config['content_service'] || {}
rescue Errno::ENOENT
  {}
end

def cms_config
  config = YAML.load_file(Rails.root + 'config/rails_connector.yml')
  config['cms_api'] || {}
rescue Errno::ENOENT
  {}
end

RailsConnector::Configuration.content_service_url = ENV['CONTENT_SERVICE_URL'] || content_service_config['url']
RailsConnector::Configuration.content_service_login = ENV['CONTENT_SERVICE_LOGIN'] || content_service_config['login']
RailsConnector::Configuration.content_service_api_key = ENV['CONTENT_SERVICE_API_KEY'] || content_service_config['api_key']

RailsConnector::Configuration.cms_url = ENV['CMS_URL'] || cms_config['url']
RailsConnector::Configuration.cms_login = ENV['CMS_LOGIN'] || cms_config['login']
RailsConnector::Configuration.cms_api_key = ENV['CMS_API_KEY'] || cms_config['api_key']

RailsConnector::Configuration.choose_homepage do |env|
  # Returns an introduction page, when no Homepage found. Usually, you can delete
  # the NullHomepage.new fallback once you first published your content. See
  # "app/controllers/null_homepage_controller.rb" and
  # "app/models/null_homepage.rb" as well.
  Homepage.for_hostname(Rack::Request.new(env).host) || NullHomepage.new
end

# This callback is important for security.
#
# It is used to provide inplace editing features. Even if you don't use inplace editing
# on the client side, the server side also uses this callback to determine if CMS data
# can be modified in the database.
RailsConnector::Configuration.editing_auth do |env|
  EditModeDetection.editing_allowed?(env)
end
