class CreateSearchPageExample < ::RailsConnector::Migration
  def up
    path = '<%= configuration_path %>/search'

    create_obj(
      _path: path,
      _obj_class: '<%= class_name %>'
    )

    attributes = get_obj_class('Homepage')['attributes']
    attributes << <%= search_page_attribute.inspect %>

    update_obj_class('Homepage', attributes: attributes)

    update_obj(
      Obj.find_by_path('<%= homepage_path %>').id,
      '<%= search_page_attribute[:name] %>' => [{ url: path }]
    )
  end
end