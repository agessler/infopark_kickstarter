class <%= class_name %> < <%= object_class %>
  <%- attributes.each do |definition| -%>
  <%= generate_attribute_method(definition) %>
  <%- end -%>

  # Uncomment the the following line to share common behavior for CMS pages.
  # include Page
end
