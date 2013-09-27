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

  def add_widget(obj, attribute, widget)
    widget.reverse_merge!({
      _path: "_widgets/#{obj.id}/#{SecureRandom.hex(8)}",
    })

    widget = create_obj(widget)

    revision_id = RailsConnector::Workspace.current.revision_id
    definition = RailsConnector::CmsRestApi.get("revisions/#{revision_id}/objs/#{obj.id}")

    widgets = definition[attribute] || {}
    widgets['layout'] ||= []
    widgets['layout'] << { widget: widget['id'] }

    update_obj(definition['id'], attribute => widgets)
  end
end