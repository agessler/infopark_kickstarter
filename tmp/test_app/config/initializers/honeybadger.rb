def honeybadger_config
  config = YAML.load_file(Rails.root + 'config/custom_cloud.yml')
  config['honeybadger'] || {}
rescue Errno::ENOENT
  {}
end

Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_KEY'] || honeybadger_config['api_key']
end
