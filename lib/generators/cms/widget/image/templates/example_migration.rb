require 'open-uri'

class CreateImageWidgetExample < RailsConnector::Migration
  def up
    homepage = Obj.find_by_path("<%= example_cms_path %>")

    asset_url = 'http://lorempixel.com/1170/400/abstract'

    asset = create_obj({
      _obj_class: 'Image',
      _path: "_resources/#{SecureRandom.hex(8)}/example_image.jpg",
      blob: upload_file(open(asset_url)),
    })

    add_widget(homepage, "<%= example_widget_attribute %>", {
      _obj_class: "<%= obj_class_name %>",
      source: asset['id'],
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