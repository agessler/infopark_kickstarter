$ ->
  # This file integrates an editor for linklist attributes.

  template = (attributes) ->
    attributes ||= {}

    title = attributes['title'] || ''
    url = attributes['url'] || ''

    $("<input type=\"text\" name=\"title\" value=\"#{title}\" placeholder=\"Title\" />
       <input type=\"text\" name=\"url\" value=\"#{url}\" placeholder=\"Url\" />
       <a href=\"#\" class=\"editing-button editing-red\">
         <i class=\"editing-icon editing-icon-cancel\" />
       </a>")

  getCmsField = (element) ->
    element.closest('[data-ip-field-type=linklist]')

  save = (cmsField) ->
    value = getAttributes(cmsField)
    lastSaved = getLastSaved(cmsField)

    unless JSON.stringify(value) == JSON.stringify(lastSaved)
      cmsField.infopark('save', value).done ->
        storeLastSaved(cmsField, value)

  getAttributes = (cmsField) ->
    items = $(cmsField).find('li')

    value =
      for item in items
        item = $(item)

        'title': item.find('[name=title]').val()
        'url': item.find('[name=url]').val()

  addLink = (event) ->
    event.preventDefault()

    cmsField = getCmsField($(event.currentTarget))
    content = $('<li>').html(template())

    cmsField.find('ul').append(content)

  removeLink = (event) ->
    event.preventDefault()

    target = $(event.currentTarget)
    cmsField = getCmsField(target)

    target.closest('li').remove()
    save(cmsField)

  transformLinks = (cmsFields) ->
    items = cmsFields.find('li')

    for item in items
      item = $(item)

      content = template
        title: item.data('title')
        url: item.data('url')

      item.html(content)

  getLastSaved = (cmsField) ->
    cmsField.data('last-saved')

  storeLastSaved = (cmsField, value) ->
    $(cmsField).data('last-saved', value)

  onBlur = (event) ->
    cmsField = getCmsField($(event.currentTarget))

    save(cmsField)

  infopark.on 'new_content', (root) ->
    linklistElements = $(root).find('[data-ip-field-type=linklist]')

    if linklistElements.length
      transformLinks(linklistElements)

      for linklistElement in linklistElements
        storeLastSaved(linklistElement, getAttributes(linklistElement))

      linklistElements.on 'blur', 'li input', onBlur
      linklistElements.on 'click', 'li a', removeLink
      linklistElements.on 'click', 'button.add-link', addLink

      linklistElements.find('ul').sortable
        update: (event) ->
          cmsField = getCmsField($(event.target))

          save(cmsField)
