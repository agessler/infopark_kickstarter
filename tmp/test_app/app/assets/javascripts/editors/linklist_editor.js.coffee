$ ->
  # This file integrates an editor for linklist attributes.

  template = (attributes) ->
    attributes ||= {}

    title = attributes['title'] || ''
    url = attributes['url'] || ''

    $("<input type=\"text\" name=\"title\" value=\"#{title}\" placeholder=\"Title\" />
       <input type=\"text\" name=\"url\" value=\"#{url}\" placeholder=\"Url\" class=\"editing-url\" />
       <a href=\"#\" class=\"editing-button mediabrowser-open\">
         &hellip;
       </a>
       <a href=\"#\" class=\"editing-button editing-red delete\">
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

  # run when clicking the '...' button inside a li
  onOpenMediabrowser = (event) ->
    event.preventDefault()

    linkItem = $(event.currentTarget).closest('li')

    Mediabrowser.open
      allowedLength: 1
      selection: []
      onSave: (selection) =>
        onMediabrowserSaveLinkItem(selection, linkItem)

  # media browser callback for saving a single link
  onMediabrowserSaveLinkItem = (selection, linkItem) ->
    url = buildUrl(selection[0])
    linkItem.find('[name=url]').val(url)

    # trigger save after inserting the value
    cmsField = getCmsField(linkItem)
    save(cmsField)

    true

  getAttributes = (cmsField) ->
    items = $(cmsField).find('li')

    value =
      for item in items
        item = $(item)

        'title': item.find('[name=title]').val()
        'url': item.find('[name=url]').val()

  # Transforms an obj id into an url that can be parsed by the RailsConnector
  # to establish an internal link.
  buildUrl = (id) ->
    "#{document.location.origin}/#{id}"

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
        length: item.data('length')

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
      linklistElements.on 'click', 'li a.delete', removeLink
      linklistElements.on 'click', 'button.add-link', addLink
      linklistElements.on 'click', 'a.mediabrowser-open', onOpenMediabrowser

      linklistElements.find('ul').sortable
        update: (event) ->
          cmsField = getCmsField($(event.target))

          save(cmsField)
