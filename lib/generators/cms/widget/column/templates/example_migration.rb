class CreateColumn<%= columns %>WidgetExample < RailsConnector::Migration
  def up
    homepage = Obj.find_by_path("<%= example_cms_path %>")

    add_widget(homepage, "<%= example_widget_attribute %>", {
      _obj_class: "<%= obj_class_name %>",
    })
  end

  private

  {
    _obj_class: 'Homepage',
    _widget_pool: {
      SecureRandom.hex(4): {
        _obj_class: 'ColumnWidget',
        columns: '3'
      }
    }
  }

  def add_widget(obj, attribute, widget)
    widgets = definition[attribute] || {}
    widgets['layout'] ||= []
    widgets['layout'] << { widget: widget['id'] }

    update_obj(obj.id, attribute => widgets)
  end
end
