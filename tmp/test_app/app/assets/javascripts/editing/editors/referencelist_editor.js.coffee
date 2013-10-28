$ ->
  # An editor for CMS referencelist attributes.

  # Creates the DOM for one reference element of the referencelist and substitutes the
  # name and id attribute.
  template = (attributes) ->
    attributes ||= {}

    name = attributes['name'] || ''
    id = attributes['id'] || ''

    $("<div>#{name} (#{id})</div>
       <div class=\"actions\">
         <a href=\"#\" class=\"editing-button editing-red delete\">
           <i class=\"editing-icon editing-icon-trash\" />
         </a>
       </div>")

  # Returns the closest referencelist DOM element.
  getCmsField = (element) ->
    element.closest('[data-ip-field-type=referencelist]')

  # Saves the referencelist to the CMS when changed and stores the last successfully saved value.
  save = (ids, cmsField) ->
    lastSaved = getLastSaved(cmsField)

    unless JSON.stringify(ids) == JSON.stringify(lastSaved)
      cmsField.addClass('saving')

      cmsField.infopark('save', ids)
        .done ->
          storeLastSaved(cmsField, ids)
          cmsField.trigger('infopark_reload')
        .fail ->
          cmsField.removeClass('saving')

  # Run when clicking the media browser button.
  onMediabrowserOpen = (event) ->
    event.preventDefault()

    cmsField = getCmsField($(event.currentTarget))
    ids = getIds(cmsField)

    Mediabrowser.open
      selection: ids

      onSave: (selection) =>
        save(selection, cmsField)

  # Collects all reference ids for a given referencelist.
  getIds = (cmsField) ->
    items = $(cmsField).find('li')

    value =
      for item in items
        $(item).data('id')

  # Removes a single reference from the referencelist.
  remove = (event) ->
    event.preventDefault()

    target = $(event.currentTarget)
    cmsField = getCmsField(target)

    target.closest('li').remove()

    ids = getIds(cmsField)
    save(ids, cmsField)

  # Turns the server side generated referencelist data into the reference editor using a template.
  transform = (elements) ->
    items = elements.find('li')

    for item in items
      item = $(item)

      content = template
        id: item.data('id')
        name: item.data('name')

      item.html(content)

  # Returns the last saved value.
  getLastSaved = (cmsField) ->
    $(cmsField).data('last-saved')

  # Stores a given value as last saved.
  storeLastSaved = (cmsField, value) ->
    $(cmsField).data('last-saved', value)

  # Initialize referencelist editor and setup event callbacks.
  infopark.on 'new_content', (root) ->
    elements = $(root).find('[data-ip-field-type=referencelist]')

    if elements.length
      transform(elements)

      for element in elements
        ids = getIds(element)
        storeLastSaved(element, ids)

      elements.on 'click', 'li a.delete', remove
      elements.on 'click', 'button.mediabrowser-open', onMediabrowserOpen

      elements.find('ul').sortable
        update: (event) ->
          cmsField = getCmsField($(event.target))
          ids = getIds(cmsField)

          save(ids, cmsField)
