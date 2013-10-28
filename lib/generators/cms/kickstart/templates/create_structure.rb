class CreateStructure < ::RailsConnector::Migration
  def up
    delete_obj_by_path('/logo.png')
    delete_obj_by_path('/')

    try_update_obj_class('Publication', is_active: false)

    try_create_obj(_path: '/', _obj_class: 'Root')
    try_update_obj_class('Root', is_active: false)

    try_create_obj(_path: "<%= website_path %>", _obj_class: 'Website')

    try_create_obj(_path: "<%= homepage_path %>", _obj_class: 'Homepage', locale: 'en', headline: 'Company, Inc.', title: 'Company, Inc.')

    try_create_obj(_path: "<%= configuration_path %>", _obj_class: 'Container')

    try_create_obj(_path: "<%= homepage_path %>/example-page", _obj_class: 'ContentPage', headline: 'Content Page', show_in_navigation: 'Yes', title: 'Content Page')

    error_not_found_page = try_create_obj(_path: "<%= configuration_path %>/error-not-found", _obj_class: 'ErrorPage', headline: 'Page not found', show_in_navigation: 'No')

    try_update_obj(
      Obj.find_by_path("<%= homepage_path %>").id,
      error_not_found_page: error_not_found_page['id'],
    )

    try_create_obj(_path: "<%= resources_path %>", _obj_class: 'ResourceContainer', headline: 'Resources')
    try_create_obj(_path: "<%= resources_path %>/images", _obj_class: 'Container', headline: 'Images')
    try_create_obj(_path: "<%= resources_path %>/audio", _obj_class: 'Container', headline: 'Audio')
    try_create_obj(_path: "<%= resources_path %>/videos", _obj_class: 'Container', headline: 'Videos')
    try_create_obj(_path: "<%= resources_path %>/pdfs", _obj_class: 'Container', headline: 'Pdfs')
  end

  private

  def try_update_obj_class(id, attributes)
    update_obj_class(id, attributes)
  rescue RailsConnector::ClientError => error
    warning(error)
  end

  def try_create_obj(attributes = {})
    create_obj(attributes)
  rescue RailsConnector::ClientError => error
    warning(error)
  end

  def try_update_obj(id, attributes = {})
    update_obj(id, attributes)
  rescue RailsConnector::ClientError => error
    warning(error)
  end

  def warning(error)
    puts error.message
    puts 'Some aspects of the Infopark Kickstarter may not work as expected.'
  end

  def delete_obj_by_path(path)
    obj = Obj.find_by_path(path)

    if obj
      delete_obj(obj.id)
    else
      puts "[delete obj] The object at '#{path}' does not exist."
    end
  end
end
