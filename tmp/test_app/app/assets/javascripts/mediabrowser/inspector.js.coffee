class @MediabrowserInspector
  containmentSelector = '.inspector'

  initializeBindings = ->
    @modal.on 'click', 'tr.inspect', (event) =>
      onInspect.call(@, event)

    @modal.on 'click', 'a.inspector-close', (event) =>
      event.preventDefault()
      @close()

  onInspect = (event) ->
    unless $(event.target).is(':checkbox')
      element = $(event.currentTarget)
      id = element.data('id')

      @open(id)

  findContainment = ->
    @modal.find(containmentSelector)

  constructor: (@modal) ->
    initializeBindings.call(@)

  open: (id) ->
    containment = findContainment.call(@)

    data =
      id: id

    $.ajax
      url: '/mediabrowser/edit'
      dataType: 'json'
      data: data
      success: (json) =>
        containment.html(json.content)
        infopark.editing.refresh(containment)

  close: ->
    containment = findContainment.call(@)

    containment.html('')