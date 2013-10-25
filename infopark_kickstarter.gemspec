$:.push File.expand_path('../lib', __FILE__)

require 'infopark_kickstarter/version'

Gem::Specification.new do |gem|
  gem.platform    = Gem::Platform::RUBY
  gem.name        = 'infopark_kickstarter'
  gem.version     = InfoparkKickstarter::VERSION
  gem.summary     = 'Infopark Kickstarter'
  gem.description = 'Infopark Kickstarter'
  gem.has_rdoc    = 'yard'

  gem.required_ruby_version     = Gem::Requirement.new('>= 1.9')
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.8')

  gem.license = 'LGPLv3'

  gem.authors   = ['Infopark AG']
  gem.email     = ['info@infopark.de']
  gem.homepage  = 'http://www.infopark.de'

  gem.bindir      = 'bin'
  gem.executables = []
  gem.test_files  = Dir['spec/**/*']
  gem.files       = Dir[
    'app/**/*',
    'lib/**/*',
    'LICENSE',
    'Rakefile',
    'README.md',
    'CHANGELOG.md'
  ]

  gem.add_dependency 'bundler'
  gem.add_dependency 'rails'
  gem.add_dependency 'launchy'
  gem.add_dependency 'infopark_cloud_connector', '>= 6.9.5'

  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'redcarpet'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'generator_spec'
end
