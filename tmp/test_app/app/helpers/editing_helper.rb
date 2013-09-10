module EditingHelper
  def cms_edit_string(object, attribute_name)
    cms_tag(:div, object, attribute_name)
  end

  def cms_edit_html(object, attribute_name)
    cms_tag(:div, object, attribute_name)
  end

  def cms_edit_enum(object, attribute_name)
    cms_tag(:select, object, attribute_name) do |tag|
      cms_options_for_select(object, attribute_name)
    end
  end

  def cms_edit_multienum(object, attribute_name)
    cms_tag(:select, object, attribute_name, multiple: true) do |tag|
      cms_options_for_select(object, attribute_name)
    end
  end

  def cms_edit_date(object, attribute_name)
    value = object.send(attribute_name)

    value_string = if value.present?
      value.strftime("%Y-%m-%d")
    else
      ''
    end

    cms_tag(:div, object, attribute_name) do
     tag(:input, type: 'text', value: value_string)
    end
  end

  def cms_edit_label(object, attribute_name)
    content_tag(:h4) do
      object.cms_attribute_definition(attribute_name)['title']
    end
  end

  def cms_edit_linklist(object, attribute_name)
    linklist = object.send(attribute_name)

    template = ''
    template << cms_link_inputs

    cms_tag(:div, object, attribute_name, 'data-fields-template' => template) do
      out = cms_linklist_inputs(linklist)
      out << button_tag('+', class: 'btn')

      out.html_safe
    end
  end

  private

  def cms_options_for_select(obj, attribute)
    attribute_definition = obj.cms_attribute_definition(attribute)

    options_for_select(attribute_definition['values'], obj.send(attribute))
  end

  def cms_linklist_inputs(linklist)
    out = linklist.inject('<ul>') do |string, link|
      string << cms_link_inputs(link.title, link.url)
    end

    out << '</ul>'
  end

  def cms_link_inputs(link_title = '', link_url = '')
    value = '<li>'
    value << text_field_tag('title[]', link_title)
    value << url_field_tag('url[]', link_url)
    value << '</li>'
  end
end
