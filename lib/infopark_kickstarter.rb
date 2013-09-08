require 'rails/generators'

require 'infopark_kickstarter/engine'

require 'generators/cms/migration'
require 'generators/cms/base_paths'
require 'generators/cms/base_attributes'
require 'generators/cms/actions'
require 'generators/cms/model/api/api_generator'
require 'generators/cms/widget/example'
require 'generators/cms/widget/api/api_generator'

module InfoparkKickstarter
  extend ActiveSupport::Autoload

  autoload :Resource
  autoload :Attribute
  autoload :ObjClass
end
