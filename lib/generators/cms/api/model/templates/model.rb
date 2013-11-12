class <%= class_name %> < <%= object_class %>
  <%- attributes.each do |definition| -%>
  <%= generate_attribute_method(definition) %>
  <%- end -%>
end
