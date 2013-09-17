require 'rails/generators'

require 'infopark_kickstarter/engine'

require 'generators/cms/actions'
require 'generators/cms/attributes'
require 'generators/cms/base_paths'
require 'generators/cms/migration'
require 'generators/cms/widget/example'

require 'generators/cms/api/edit_view/edit_view_generator'
require 'generators/cms/api/locale/locale_generator'
require 'generators/cms/api/model/model_generator'
require 'generators/cms/api/obj_class/obj_class_generator'
require 'generators/cms/api/thumbnail/thumbnail_generator'
require 'generators/cms/api/widget/widget_generator'

module InfoparkKickstarter
  extend ActiveSupport::Autoload

  autoload :Resource
  autoload :Attribute
  autoload :ObjClass
end
