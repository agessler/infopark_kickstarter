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


  def cms_edit_linklist(object, attribute_name)
    linklist = object.send(attribute_name)

    content_tag(:ul) do
      out = ''.html_safe

      linklist.each do |link|
        out << content_tag(:li) do
          content_tag(:ul) do
            html = ''.html_safe

            html << content_tag(:li, I18n.t('editing.linklist.title', title: link.title))
            html << content_tag(:li, I18n.t('editing.linklist.url', url: link.url))

            html
          end
        end
      end

      out
    end
  end

  def cms_edit_label(object, attribute_name)
    content_tag(:h4) do
      object.cms_attribute_definition(attribute_name)['title']
    end
  end

  private

  def cms_options_for_select(obj, attribute)
    attribute_definition = obj.cms_attribute_definition(attribute)

    options_for_select(attribute_definition['values'], obj.send(attribute))
  end
end
