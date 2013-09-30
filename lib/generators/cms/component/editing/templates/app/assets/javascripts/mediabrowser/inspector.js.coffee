@MediabrowserInspector = do ->
  inspectorSelector: '.editing-mediabrowser-inspector'
  inspector: undefined

  contentSelector: '.inspector-content'

  objectId: undefined

  _initializeBindings: ->
    @modal.on 'click', 'li.mediabrowser-item', (event) =>
      @_onInspect(event)

    @modal.on 'click', '.delete-button', =>
      @_onDelete()

    @modal.on 'click', 'a.inspector-close', (event) =>
      event.preventDefault()
      @close()

    @inspector = @modal.find(@inspectorSelector)

  _onInspect: (event) ->
    unless $(event.target).hasClass('select-item')
      currentTarget = $(event.currentTarget)
      id = currentTarget.data('id')

      if id
        @open(id)
        @_highlightItem(currentTarget)

  _onDelete: ->
    @_renderLoading()
    infopark.delete_obj(@objectId).done =>
      @close
      @modal.trigger('mediabrowser.refresh')

  _renderLoading: ->
    @inspector.html('
      <div class="editing-mediabrowser-loading">
        <i class="editing-icon editing-icon-refresh"></i>
      </div>
    ')

  _highlightItem: (element) ->
    @modal.find('li.mediabrowser-item.active').removeClass('active')
    element.addClass('active')

  init: (modal) ->
    @modal = modal
    @_initializeBindings()

  open: (objectId) ->
    @objectId = objectId

    @inspector.show()
    @_renderLoading()

    data =
      id: @objectId

    $.ajax
      url: '/mediabrowser/edit'
      dataType: 'json'
      data: data
      success: (json) =>
        @inspector.html(json.content)
        infopark.editing.refresh(@inspector)
      error: =>
        @inspector.html('')

  close: ->
    @inspector.html('')
    @inspector.hide()
