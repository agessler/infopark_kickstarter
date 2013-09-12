@MediabrowserInspector = do ->
  containerSelector: '.inspector'

  _initializeBindings: ->
    @modal.on 'click', 'tr.inspect', (event) =>
      @_onInspect(event)

    @modal.on 'click', 'a.inspector-close', (event) =>
      event.preventDefault()
      @close()

  _onInspect: (event) ->
    unless $(event.target).is(':checkbox')
      element = $(event.currentTarget)
      id = element.data('id')

      @open(id)

  _findContainer: ->
    @modal.find(@containerSelector)

  init: (modal) ->
    @modal = modal
    @_initializeBindings()

  open: (id) ->
    container = @_findContainer()

    data =
      id: id

    $.ajax
      url: '/mediabrowser/edit'
      dataType: 'json'
      data: data
      success: (json) =>
        container.html(json.content)
        infopark.editing.refresh(container)

  close: ->
    @_findContainer().html('')
