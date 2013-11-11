class CreateHeadlineWidgetExample < RailsConnector::Migration
  def up
    homepage = Obj.find_by_path("<%= example_cms_path %>")

    add_widget(homepage, "<%= example_widget_attribute %>", {
      _obj_class: "<%= obj_class_name %>",
      headline: 'Integer eget justo at ipsum interdum mattis'
    })
  end

  private

  def add_widget(obj, attribute, widget_params)
    workspace_id = RailsConnector::Workspace.current.id
    definition = RailsConnector::CmsRestApi.get("workspace/#{workspace_id}/objs/#{obj.id}")

    widget_id = SecureRandom.hex(4)
    definition['_widget_pool'] = {
      widget_id => widget_params
    }

    widget = definition[attribute] || {}
    widget['list'] ||= []
    widget['list'] << { widget: widget_id }

    update_obj(definition['id'], attribute => widget)
  end
end
