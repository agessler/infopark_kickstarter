@Mediabrowser = do ->
  modalSelector: '#editing-mediabrowser'
  overlayBackgroundSelector: '.editing-overlay'
  loadingSelector: '.editing-mediabrowser-loading'
  options: {}

  _setDefaults: ->
    @query = ''
    @objClass = undefined
    @thumbnailSize = 'normal'
    @selected = @options.selection || []

  _highlightFilter: (filterItem) ->
    filterItems = @modal.find('li.filter')
    filterItems.removeClass('active')

    filterItem ||= filterItems.filter('.all')
    $(filterItem).addClass('active')

  _onFilter: (event) ->
    event.preventDefault()

    target = $(event.currentTarget)
    @objClass = target.data('obj-class')
    @showSelection = target.hasClass('selected-items')

    @_highlightFilter(target)
    @_renderPlaceholder()

  _save: ->
    (@options.onSave || $.noop)(@selected)

    @close()

  _getItemId: (item) ->
    $(item).closest('li.mediabrowser-item').data('id')

  _addItem: (item) ->
    @_activateItem(item)

    id = @_getItemId(item)

    @selected.push(id)
    @selected = $.unique(@selected)

    @_changeSelectedTotal()

  _removeItem: (item) ->
    @_deactivateItem(item)

    @selected = @selected.filter (id) =>
      id != @_getItemId(item)

    @_changeSelectedTotal()

  _activateItem: (item) ->
    $(item).addClass('active')

  _deactivateItem: (item) ->
    $(item).removeClass('active')

  _changeSelectedTotal: ->
    @modal.find('.selected-total').html(@selected.length)

  _deselectAllItems: ->
    @selected = []
    @modal.find('li.mediabrowser-item .select-item.active').removeClass('active')

  _getItems: ->
    @modal.find('.editing-mediabrowser-items')

  _getContainer: ->
    @modal.find('.editing-mediabrowser-thumbnails')

  _calculateViewportValues: ->
    container = @_getContainer()
    items = @_getItems()

    # Takes the height of the container and substract the padding of the <ul> tag.
    containerHeight = items.height() - container.pixels('padding-top')

    # Get the width of the ul without left and right padding and the scrollbar of the parent <div>.
    containerWidth = container.width()

    # Take the first container and get the width and height including margins, paddings and borders.
    item = @modal.find('li.mediabrowser-item')
    lineHeight = item.outerHeight(true)
    rowWidth = item.outerWidth(true)

    elementsPerRow = Math.floor(containerWidth / rowWidth)
    rows = Math.ceil(containerHeight / lineHeight)

    # Determine the position the user scrolled to.
    scrollPosition = items.scrollTop()

    viewLimit = (elementsPerRow * rows)
    viewIndex = Math.round(scrollPosition / lineHeight) * elementsPerRow

    [viewIndex, viewLimit]

  _renderContainerForItems: (containerTotal) ->
    content = for index in [0...containerTotal] by 1
      "<li class='mediabrowser-item' data-index='#{index}'>
        <div class='editing-mediabrowser-loading'>
          <i class='editing-icon editing-icon-refresh'></i>
        </div>
      </li>"
    content = ("<ul class='items editing-mediabrowser-thumbnails #{@thumbnailSize}'>#{content.join('')}</ul>")

    @_getItems().html(content)

  _updateViewport: ->
    return unless @_getContainer().length

    [viewIndex, viewLimit] = @_calculateViewportValues()

    [alreadyLoaded, viewIndex] = @_getStartIndex(viewIndex, viewLimit)

    unless alreadyLoaded
      @_renderContents(viewIndex, viewLimit)

  _getStartIndex: (viewIndex, viewLimit) ->
    maxIndex = viewIndex + viewLimit

    for index in [viewIndex...maxIndex] by 1
      element = @_findItemByIndex(index)

      unless element.data('id')
        return [false, index]

    [true, viewIndex]

  _queryOptions: ->
    selected: @selected
    query: @query
    obj_classes: [@objClass]
    thumbnail_size: @thumbnailSize
    selected_only: @showSelection

  _renderPlaceholder: ->
    @_renderLoading()
    query = @_queryOptions()

    $.ajax
      url: '/mediabrowser'
      dataType: 'json'
      data: query
      success: (json) =>
        total = json.meta.total

        if total > 0
          @_renderContainerForItems(total)
          @_updateViewport()
        else
          @_renderNoResults()

  _renderContents: (viewIndex, viewLimit) ->
    query = @_queryOptions()
    query['limit'] = viewLimit
    query['offset'] = viewIndex

    $.ajax
      url: '/mediabrowser'
      dataType: 'json'
      data: query
      success: (json) =>
        @_replacePlaceholder(json.objects, viewIndex)

  _findItemByIndex: (index) ->
    @modal.find("li.mediabrowser-item[data-index=#{index}]")

  _replacePlaceholder: (objects, viewIndex) ->
    $(objects).each (index, object) =>
      elementsViewIndex = index + viewIndex
      element = @_findItemByIndex(elementsViewIndex)
      element.html(object.content)
      element.data('id', object.id)

  _setTimer: ->
    if @timer
      clearTimeout(@timer)

    @timer = setTimeout =>
      @_updateViewport()
    , 500

  _triggerSearch: ->
    @query = @modal.find('input.search-field').val()
    @_renderPlaceholder()

  _initializeBindings: ->
    $(window).resize ->
      $('#editing-mediabrowser.show').center()

    $(document).on 'keyup', (event) =>
      if event.keyCode == 27
        @close()

    @modal.on 'keyup', 'input.search-field', (event) =>
      if event.keyCode == 13
        @_triggerSearch()

    @modal.on 'click', 'button.search-field-button', (event) =>
      event.preventDefault()

      @_triggerSearch()

    @modal.on 'click', 'li.mediabrowser-item .select-item:not(.active)', (event) =>
      event.stopImmediatePropagation()

      if @options.allowedLength == 1
        @_deselectAllItems()

      @_addItem(event.currentTarget)

    @modal.on 'click', 'li.mediabrowser-item .select-item.active', (event) =>
      event.stopImmediatePropagation()
      @_removeItem(event.currentTarget)

    @modal.on 'click', '.mediabrowser-save', (event) =>
      event.preventDefault()

      @_save()

    @modal.on 'click', '.mediabrowser-close', (event) =>
      event.preventDefault()

      @close()

    @modal.on 'click', 'li.filter', (event) =>
      @_onFilter(event)

    @modal.on 'click', '.editing-button-view', (event) =>
      size = $(event.currentTarget).data('size')
      @_changeThumbnailSize(size)

    @modal.on 'mediabrowser.refresh', =>
      @_renderPlaceholder()

    # Bind events, which require the dom to be present.
    @modal.on 'mediabrowser.markupLoaded', =>
      @_getItems().on 'scroll', =>
        @_setTimer()

      @_changeThumbnailSize(@thumbnailSize)

  _initializeUploader: ->
    MediabrowserUploader.init(@modal)

    MediabrowserUploader.onUploadStart = (obj) =>
      @_renderLoading()

    MediabrowserUploader.onUploadFailure = (error) =>
      console.log('Mediabrowser Uploader Error:', error)

    MediabrowserUploader.onUploadSuccess = (objs) =>
      @_renderPlaceholder()

  _loadModalMarkup: ->
    @modal.html('')

    $.ajax
      url: '/mediabrowser/modal'
      dataType: 'json'
      success: (json) =>
        @modal.html(json.content)

        @_highlightFilter()
        @_renderPlaceholder()
        @_changeSelectedTotal()

        MediabrowserInspector.init(@modal)
        @_initializeUploader()

        @modal.trigger('mediabrowser.markupLoaded')

  _renderNoResults: ->
    @_getItems().html('')

  _renderLoading: ->
    @_getItems().html('
      <div class="editing-mediabrowser-loading">
        <i class="editing-icon editing-icon-refresh"></i>
      </div>')

  _changeThumbnailSize: (size) ->
    @thumbnailSize = size

    transitionListener = 'webkitTransitionEnd.mediabrowser otransitionend.mediabrowser oTransitionEnd.mediabrowser msTransitionEnd.mediabrowser transitionend.mediabrowser'
    @modal.on transitionListener, 'li.mediabrowser-item', (event) =>
      @_updateViewport()
      @modal.off transitionListener

    @_getContainer()
      .removeClass('small normal big large')
      .addClass(size)

    @_activateThumbnailView(size)

  _activateThumbnailView: (size) ->
    button = @modal.find('.editing-button-view')
    button.removeClass('active')
    button.filter("[data-size='#{size}']").addClass('active')

  init: ->
    unless $(@overlayBackgroundSelector).length
      @overlay = $('<div class="editing-overlay hide"></div>')
      $('body').append @overlay

    unless $(@modalSelector).length
      @modal = $('<div id="editing-mediabrowser" class="editing-mediabrowser hide"></div>')
      $('body').append @modal

    @_initializeBindings()

  toggle: (value) ->
    @overlay.toggleClass('show', value)
    @modal.toggleClass('show', value)

  close: ->
    (@options.onClose || $.noop)()

    @toggle(false)

  open: (options) ->
    @options = options
    @_setDefaults()

    @_loadModalMarkup()

    @toggle(true)
    @modal.center()

$ ->
  Mediabrowser.init()
