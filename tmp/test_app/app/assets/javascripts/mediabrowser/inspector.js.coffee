@MediabrowserInspector = do ->
  inspectorSelector: '.editing-mediabrowser-inspector'
  inspector: undefined

  contentSelector: '.inspector-content'
  contentContainer: undefined

  objectId: undefined

  _initializeBindings: ->
    @modal.on 'click', 'li.mediabrowser-item', (event) =>
      @_onInspect(event)

    @modal.on 'click', '.delete-button', (event) =>
      console.log("Delete called for #{@objectId}")

    @modal.on 'click', 'a.inspector-close', (event) =>
      event.preventDefault()
      @close()

    @contentContainer = @modal.find(@contentSelector)
    @inspector = @modal.find(@inspectorSelector)

  _onInspect: (event) ->
    unless $(event.target).hasClass('select-item')
      currentTarget = $(event.currentTarget)
      id = currentTarget.data('id')

      if id
        @open(id)
        @_highlightItem(currentTarget)

  _highlightItem: (element) ->
    @modal.find('li.mediabrowser-item.active').removeClass('active')
    element.addClass('active')

  init: (modal) ->
    @modal = modal
    @_initializeBindings()

  open: (objectId) ->
    @objectId = objectId

    @inspector.show()
    @contentContainer.html('
      <div class="editing-mediabrowser-loading">
        <i class="editing-icon editing-icon-refresh"></i>
      </div>
    ')

    data =
      id: @objectId

    $.ajax
      url: '/mediabrowser/edit'
      dataType: 'json'
      data: data
      success: (json) =>
        @contentContainer.html(json.content)
        @_updateTitle(json.meta.title)
        infopark.editing.refresh(@contentContainer)

  close: ->
    @contentContainer.html('')
    @inspector.hide()

  _updateTitle: (title) ->
    @inspector.find('span.title').text(title)
