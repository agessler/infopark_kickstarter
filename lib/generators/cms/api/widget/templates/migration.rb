class Create<%= class_name %> < ::RailsConnector::Migration
  def up
    create_obj_class(
      name: '<%= class_name %>',
      type: 'publication',
      title: '<%= title %>',
      attributes: [
        <%- attributes.each do |definition| -%>
        <%= definition.inspect %>,
        <%- end -%>
      ],
      preset_attributes: <%= preset_attributes.inspect %>,
      mandatory_attributes: <%= mandatory_attributes.inspect %>
    )
  end
end
