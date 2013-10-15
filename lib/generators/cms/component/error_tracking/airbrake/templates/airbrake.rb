def airbrake_config
  config = YAML.load_file(Rails.root + 'config/custom_cloud.yml')
  config['airbrake'] || {}
rescue Errno::ENOENT
  {}
end

Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY'] || airbrake_config['api_key']
  config.secure = true
end
