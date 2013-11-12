class CreateSliderWidgetExample < RailsConnector::Migration
  def up
    homepage = Obj.find_by_path("<%= example_cms_path %>")

    urls = [
      'http://lorempixel.com/1170/400/abstract',
      'http://lorempixel.com/1170/400/sports',
      'http://lorempixel.com/1170/400/city',
    ]

    image_ids = urls.map do |url|
      image = create_obj({
        _obj_class: 'Image',
        _path: "_resources/#{SecureRandom.hex(8)}/example_image.jpg",
        blob: upload_file(open(url)),
      })

      image['id']
    end

    add_widget(homepage, "<%= example_widget_attribute %>", {
      _obj_class: "<%= obj_class_name %>",
      images: image_ids,
    })
  end

  private

  def add_widget(obj, attribute, widget_params)
    workspace_id = RailsConnector::Workspace.current.id
    obj_params = RailsConnector::CmsRestApi.get("workspaces/#{workspace_id}/objs/#{obj.id}")
    widget_id = RailsConnector::BasicObj.generate_widget_pool_id

    params = {}
    params['_widget_pool'] = { widget_id => widget_params }
    params[attribute] = obj_params[attribute] || {}
    params[attribute]['list'] ||= []
    params[attribute]['list'] << { widget: widget_id }

    update_obj(obj_params['id'], params)
  end
end
