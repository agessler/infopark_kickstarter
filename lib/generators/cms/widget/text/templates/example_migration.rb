class CreateTextWidgetExample < RailsConnector::Migration
  def up
    homepage = Obj.find_by_path("<%= example_cms_path %>")

    add_widget(homepage, "<%= example_widget_attribute %>", {
      _obj_class: "<%= obj_class_name %>",
      content: '<p>Nullam sed velit libero. Nullam pharetra metus non justo lobortis, eu vehicula magna
        mollis. Suspendisse feugiat volutpat neque, eget volutpat nulla. Phasellus non ipsum ac
        ipsum venenatis iaculis. Maecenas dictum congue nulla id fringilla. Suspendisse sit amet
        enim dapibus, volutpat dui quis, suscipit nunc. Morbi imperdiet pellentesque augue, at
        ornare mauris consectetur faucibus.</p>'
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
