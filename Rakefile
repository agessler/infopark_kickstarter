#!/usr/bin/env rake

require 'bundler/setup'
Bundler::GemHelper.install_tasks

require 'yard'
YARD::Rake::YardocTask.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'infopark_kickstarter/rake/integration_task'
InfoparkKickstarter::Rake::IntegrationTask.new

require 'infopark_kickstarter/rake/travis_task'
InfoparkKickstarter::Rake::TravisTask.new

task default: :spec
