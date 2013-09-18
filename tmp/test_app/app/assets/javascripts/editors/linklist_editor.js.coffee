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

  save = (event) ->
    field = $(event.currentTarget)
    cmsField = getCmsField(field)

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

  dragged_item = undefined

  dragstart_reorder = (event) ->
    console.log 'dragstart'
    dragged_item = event.currentTarget
    value = $(event.currentTarget).html()
    dataTransfer = event.originalEvent.dataTransfer

    console.log 'value', value

    dataTransfer.effectAllowed = 'move'
    dataTransfer.setData('text', value)

  dragleave_reorder = (event) ->
    console.log 'dragleave'
    event.preventDefault()

    event.currentTarget.style.border = '5px solid #FFF'

  dragenter_reorder = (event) ->
    console.log 'dragenter'
    event.preventDefault()

  dragover_reorder = (event) ->
    console.log 'dragover'
    event.preventDefault()

    event.currentTarget.style.border = '5px dashed #FF0000'

  dropped_reorder = (event) ->
    console.log 'dropped'
    event.preventDefault()

    console.log 'value2', $(event.currentTarget).html()
    dragged_item.innerHTML = event.currentTarget.innerHTML

    event.currentTarget.innerHTML = event.originalEvent.dataTransfer.getData('text')
    event.currentTarget.style.border = '5px solid #FFF'

  infopark.on 'new_content', (root) ->
    linklistElements = $(root).find('[data-ip-field-type=linklist]')

    if linklistElements.length
      transformLinks(linklistElements)

      linklistElements.on 'blur', 'li input', save
      linklistElements.on 'click', 'li a', removeLink
      linklistElements.on 'click', 'a.add-link', addLink

      linklistElements.on 'dragstart', 'li', dragstart_reorder
      linklistElements.on 'dragleave', 'li', dragleave_reorder
      linklistElements.on 'dragenter', 'li', dragenter_reorder
      linklistElements.on 'dragover', 'li', dragover_reorder
      linklistElements.on 'drop', 'li', dropped_reorder
