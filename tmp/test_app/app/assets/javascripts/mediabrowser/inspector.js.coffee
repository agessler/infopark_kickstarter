@MediabrowserInspector = do ->
  inspectorSelector: '.editing-mediabrowser-inspector'
  containerSelector: '.inspector-content'
  container: undefined

  _initializeBindings: ->
    @modal.on 'click', 'li.mediabrowser-item', (event) =>
      @_onInspect(event)

    @modal.on 'click', '.delete-button', (event) =>
      id = $(event.currentTarget).data('id')
      console.log("Delete called for #{id}")

    @modal.on 'click', 'a.inspector-close', (event) =>
      event.preventDefault()
      @close()

    @container = @modal.find(@containerSelector)

  _onInspect: (event) ->
    unless $(event.target).hasClass('select-item')
      element = $(event.currentTarget)
      id = element.data('id')

      @open(id)

  init: (modal) ->
    @modal = modal
    @_initializeBindings()

  open: (id) ->
    $(@inspectorSelector).show()
    $(@containerSelector).html('
      <div class="editing-mediabrowser-loading">
        <i class="editing-icon editing-icon-refresh"></i>
      </div>
    ')
    data =
      id: id

    $.ajax
      url: '/mediabrowser/edit'
      dataType: 'json'
      data: data
      success: (json) =>
        @container.html(json.content)
        @_updateId(id)
        @_updateTitle(json.meta.title)
        infopark.editing.refresh(@container)

  close: ->
    @container.html('')
    $(@inspectorSelector).hide()

  _updateId: (id) ->
    $(@inspectorSelector).find('.delete-button').data(id: id)

  _updateTitle: (title) ->
    $(@inspectorSelector).find('span.title').text(title)
