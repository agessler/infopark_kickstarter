$ ->
  # This file integrates an editor for linklist attributes.

  template = (attributes) ->
    attributes ||= {}

    title = attributes['title'] || ''
    url = attributes['url'] || ''

    $("<input type=\"text\" name=\"title\" value=\"#{title}\" placeholder=\"Title\" />
       <input type=\"text\" name=\"url\" value=\"#{url}\" placeholder=\"Url\" />
       <a href=\"#\" class=\"editing-button\"><i class=\"editing-icon editing-icon-trash\" /></a>")

  getCmsField = (element) ->
    element.closest('[data-ip-field-type=linklist]')

  save = (cmsField) ->
    items = cmsField.find('li')

    value =
      for item in items
        item = $(item)

        'title': item.find('[name=title]').val()
        'url': item.find('[name=url]').val()

    items.addClass('saving')

    cmsField.infopark('save', value).always ->
      items.removeClass('saving')

  addLink = (event) ->
    event.preventDefault()

    cmsField = getCmsField($(event.currentTarget))
    content = $('<li draggable="true">').html(template())

    cmsField.find('ul').append(content)

  removeLink = (event) ->
    event.preventDefault()

    $(event.currentTarget).closest('li').remove()

  transformLinks = (cmsFields) ->
    items = cmsFields.find('li')

    for item in items
      item = $(item)

      content = template
        title: item.data('title')
        url: item.data('url')

      item.html(content)

  onBlur = (event) ->
    cmsField = getCmsField($(event.currentTarget))

    save(cmsField)

  infopark.on 'new_content', (root) ->
    linklistElements = $(root).find('[data-ip-field-type=linklist]')

    if linklistElements.length
      transformLinks(linklistElements)

      linklistElements.on 'blur', 'li input', onBlur
      linklistElements.on 'click', 'li a', removeLink
      linklistElements.on 'click', 'a.add-link', addLink

      linklistElements.find('ul').sortable(
        stop: (event) ->
          cmsField = getCmsField($(event.target))

          save(cmsField)
      )
