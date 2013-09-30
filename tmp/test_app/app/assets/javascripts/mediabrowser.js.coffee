@Mediabrowser = do ->
  modalSelector: '#editing-mediabrowser'
  overlayBackgroundSelector: '.editing-overlay'
  loadingSelector: '.editing-mediabrowser-loading'
  options: {}

  _setDefaults: ->
    @options ||= {}
    @query = ''
    @objClass = undefined
    @thumbnailSize = 'normal'
    @selected = @options.selection || []

  _highlightFilter: (element) ->
    @modal.find('li.filter.active').removeClass('active')

    if element
      $(element).addClass('active')
    else
      @modal.find("li.filter.all").addClass('active')

  _onFilter: (event) ->
    event.preventDefault()

    target = $(event.currentTarget)
    @objClass = target.data('obj-class')
    @showSelection = $(event.currentTarget).hasClass('selected-items')

    @_highlightFilter(target)
    @_renderPlaceholder()

  _save: () ->
    (@options.onSave || $.noop)(@selected)

    @close()

  _addItem: (element) ->
    element = $(element)
    element.addClass('active')

    id = element.closest('li.mediabrowser-item').data('id')

    @selected.push(id)
    @selected = $.unique(@selected)
    @modal.find('.selected-total').html(@selected.length)
    @_toggleSaveButton()

  _removeItem: (element) ->
    $(element).removeClass('active')
    @selected = @selected.filter (item) ->
      item != $(element).closest('li.mediabrowser-item').data('id')

    @modal.find('.selected-total').html(@selected.length)
    @_toggleSaveButton()

  _deselectAllItems: ->
    @selected = []
    items = @modal.find('li.mediabrowser-item .select-item.active')
    items.removeClass('active')

  _toggleSaveButton: ->
    @modal.find('.mediabrowser-save').toggleClass('editing-disabled', @selected.length == 0)

  _calculateViewportValues: ->
    # Takes the height of the container and substract the padding of the <ul> tag.
    containerHeight = @modal.find('.editing-mediabrowser-items').height() - @modal.find('.editing-mediabrowser-thumbnails').pixels('padding-top')
    # Get the width of the ul without left and right padding and the scrollbar of the parent <div>.
    containerWidth = @modal.find('.editing-mediabrowser-thumbnails').width()

    # Take the first container and get the width and height including margins, paddings and borders.
    lineHeight = @modal.find('li.mediabrowser-item').outerHeight(true)
    rowWidth = @modal.find('li.mediabrowser-item').outerWidth(true)

    elementsPerRow = Math.floor(containerWidth / rowWidth)
    rows = Math.ceil(containerHeight / lineHeight)

    # Determine the position the user scrolled to.
    scrollPosition = @modal.find('.editing-mediabrowser-items').scrollTop()

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

    @modal.find('.editing-mediabrowser-items').html(content)

  _updateViewport: ->
    return unless @modal.find('ul.editing-mediabrowser-thumbnails').length

    [viewIndex, viewLimit] = @_calculateViewportValues()

    [alreadyLoaded, viewIndex] = @_getStartIndex(viewIndex, viewLimit)

    unless alreadyLoaded
      @_renderContents(viewIndex, viewLimit)

  _getStartIndex: (viewIndex, viewLimit) ->
    maxIndex = viewIndex + viewLimit
    for index in [viewIndex...maxIndex] by 1
      element = $("li.mediabrowser-item[data-index=#{index}]")
      unless element.data('id')
        return [false, index]

    [true, viewIndex]

  _queryOptions: ->
    selected: @selected
    query: @query
    obj_class: @objClass
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
          @modal.find('.result-total').html(total)
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

  _replacePlaceholder: (objects, viewIndex) ->
    $(objects).each (index, object) =>
      elementsViewIndex = index + viewIndex
      element = @modal.find("li.mediabrowser-item[data-index=#{elementsViewIndex}]")
      element.html(object.content)
      element.data('id', object.id)

  _initializeBindings: ->
    $(document).on 'keyup', (event) =>
      if event.keyCode == 27
        @close()

    @modal.on 'keyup', 'input.search_field', (event) =>
      if event.keyCode == 13
        @query = $(event.target).val()
        @_renderPlaceholder()

    @modal.on 'click', 'li.mediabrowser-item .select-item:not(.active)', (event) =>
      event.stopImmediatePropagation()

      if @options.allowedLength == 1
        @_deselectAllItems()

      @_addItem(event.currentTarget)

    @modal.on 'click', 'li.mediabrowser-item .select-item.active', (event) =>
      event.stopImmediatePropagation()
      @_removeItem(event.currentTarget)

    @modal.on 'click', '.mediabrowser-save:not(.editing-disabled)', =>
      @_save()

    @modal.on 'click', '.mediabrowser-close', =>
      @close()

    @modal.on 'click', '.mediabrowser-reset', =>
      @_reset()

    @modal.on 'mediabrowser.refresh', =>
      @_renderPlaceholder()

    @modal.on 'click', 'li.filter', (event) =>
      @_onFilter(event)

    @modal.on 'click', '.editing-button-view', (event) =>
      size = $(event.currentTarget).data('size')
      @_changeThumbnailSize(size)

    @modal.on 'mediabrowser.markupLoaded', =>
      # Bind events, which require the dom to be present, here.
      @modal.find('.editing-mediabrowser-items').on 'scroll', =>
        if @timer
          clearTimeout(@timer)

        @timer = setTimeout =>
          @_updateViewport()
        , 500

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

        MediabrowserInspector.init(@modal)
        @_initializeUploader()
        @_toggleSaveButton()

        @modal.trigger('mediabrowser.markupLoaded')

  _renderNoResults: ->
    @modal.find('.editing-mediabrowser-items').html('')

  _renderLoading: ->
    @modal.find('.editing-mediabrowser-items').html('
      <div class="editing-mediabrowser-loading">
        <i class="editing-icon editing-icon-refresh"></i>
      </div>')

  _changeThumbnailSize: (size) ->
    @thumbnailSize = size

    transitionListener = 'webkitTransitionEnd.mediabrowser otransitionend.mediabrowser oTransitionEnd.mediabrowser msTransitionEnd.mediabrowser transitionend.mediabrowser'
    @modal.on transitionListener, 'li.mediabrowser-item', (event) =>
      @_updateViewport()
      @modal.off transitionListener

    $('.editing-mediabrowser-thumbnails')
      .removeClass('small normal big large')
      .addClass(size)
    $('.editing-button-view').removeClass('active')
    $(".editing-button-view[data-size='#{size}']").addClass('active')

  init: ->
    unless $(@overlayBackgroundSelector).length
      @overlay = $('<div class="editing-overlay hide"></div>')
      $('body').append @overlay

    unless $(@modalSelector).length
      @modal = $('<div id="editing-mediabrowser" class="editing-mediabrowser hide"></div>')
      $('body').append @modal

    @_initializeBindings()

  _reset: () ->
    @_setDefaults()
    @_renderPlaceholder()
    @_highlightFilter()
    @_changeThumbnailSize(@thumbnailSize)
    @modal.find('input.search_field').val('')
    MediabrowserInspector.close()

  close: () ->
    @overlay.toggleClass('show', false)
    @modal.toggleClass('show', false)

  open: (options) ->
    @options = options
    @_setDefaults()

    @_loadModalMarkup()

    @overlay.toggleClass('show', true)
    @modal.toggleClass('show', true)
    @modal.center()

$ ->
  Mediabrowser.init()

$(window).resize ->
  $('#editing-mediabrowser.show').center()
