$ ->
  # An editor for CMS linklist attributes.

  # Creates the DOM for one link element of the linklist and substitutes the
  # title and url attribute.
  template = (attributes) ->
    attributes ||= {}

    title = attributes['title'] || ''
    url = attributes['url'] || ''

    $("<input type=\"text\" name=\"title\" value=\"#{title}\" placeholder=\"Title\" />
       <input type=\"text\" name=\"url\" value=\"#{url}\" placeholder=\"Url\" />
       <span class=\"actions\">
         <a href=\"#\" class=\"editing-button editing-red\">
           <i class=\"editing-icon editing-icon-cancel\" />
         </a>
       </span>")

  # Returns the closest linklist DOM element.
  getCmsField = (element) ->
    element.closest('[data-ip-field-type=linklist]')

  # Saves the entire linklist to the CMS and stores the last successfully saved value.
  save = (cmsField) ->
    value = getAttributes(cmsField)
    lastSaved = getLastSaved(cmsField)

    unless JSON.stringify(value) == JSON.stringify(lastSaved)
      cmsField.infopark('save', value).done ->
        storeLastSaved(cmsField, value)

  # Collects all link attributes for a given linklist.
  getAttributes = (cmsField) ->
    items = $(cmsField).find('li')

    value =
      for item in items
        item = $(item)

        'title': item.find('[name=title]').val()
        'url': item.find('[name=url]').val()

  # Adds a new link to the linklist.
  addLink = (event) ->
    event.preventDefault()

    cmsField = getCmsField($(event.currentTarget))
    content = $('<li>').html(template())

    cmsField.find('ul').append(content)

  # Removes a link from the linklist.
  removeLink = (event) ->
    event.preventDefault()

    target = $(event.currentTarget)
    cmsField = getCmsField(target)

    target.closest('li').remove()
    save(cmsField)

  # Turns the server side generated linklist data into the linklist editor using a template.
  transformLinks = (cmsFields) ->
    items = cmsFields.find('li')

    for item in items
      item = $(item)

      content = template
        title: item.data('title')
        url: item.data('url')

      item.html(content)

  # Returns the last saved value.
  getLastSaved = (cmsField) ->
    cmsField.data('last-saved')

  # Stores a given value as last saved.
  storeLastSaved = (cmsField, value) ->
    $(cmsField).data('last-saved', value)

  # Automatically save when focus is lost.
  onBlur = (event) ->
    cmsField = getCmsField($(event.currentTarget))

    save(cmsField)

  # Initialize linklist editor and setup event callbacks.
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
