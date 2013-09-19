class <%= class_name %> < Obj
  <%- attributes.each do |definition| -%>
  <%= generate_attribute_method(definition) %>
  <%- end -%>

  # Most CMS objects are either a page or a box. In order for them to
  # have common behavior, uncomment one of the following lines.
  # include Page
  # include Widget
end