def crm_config
  config = YAML.load_file(Rails.root + 'config/custom_cloud.yml')
  config['crm'] || {}
rescue Errno::ENOENT
  {}
end

Infopark::Crm.configure do |config|
  config.url = ENV['CRM_URL'] || crm_config['url']
  config.login = ENV['CRM_LOGIN'] || crm_config['login']
  config.api_key = ENV['CRM_API_KEY'] || crm_config['api_key']
end
