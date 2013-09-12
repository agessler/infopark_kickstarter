@MediabrowserInspector = do ->
  containerSelector: '.inspector'
  container: undefined

  _initializeBindings: ->
    @modal.on 'click', 'tr.inspect', (event) =>
      @_onInspect(event)

    @modal.on 'click', 'a.inspector-close', (event) =>
      event.preventDefault()
      @close()

    @container = @modal.find(@containerSelector)

  _onInspect: (event) ->
    unless $(event.target).is(':checkbox')
      element = $(event.currentTarget)
      id = element.data('id')

      @open(id)

  init: (modal) ->
    @modal = modal
    @_initializeBindings()

  open: (id) ->
    data =
      id: id

    $.ajax
      url: '/mediabrowser/edit'
      dataType: 'json'
      data: data
      success: (json) =>
        @container.html(json.content)
        infopark.editing.refresh(@container)

  close: ->
    @container.html('')
