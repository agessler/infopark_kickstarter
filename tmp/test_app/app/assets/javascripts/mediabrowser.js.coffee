@Mediabrowser = do ->
  modalSelector: '#editing-mediabrowser'
  overlayBackgroundSelector: '.editing-overlay'
  loadingSelector: '.editing-mediabrowser-loading'
  itemsSelector: '.items'
  itemSelector: '.select-item'
  _setDefaults: ->
    @selected = []
    @query = ''
    @objClass = undefined
    @_setThumbnailSize('small')
    @allowedLength = undefined

  _onPageChange: (event) ->
    event.preventDefault()

    page = $(event.currentTarget).data('page')

    @_updateItems
      page: page

  _setFilterSelection: () ->
    if @objClass
      current = @modal.find("li.filter[data-obj-class='#{@objClass}']")
    else if @showSelection
      current = @modal.find("li.filter.selected-items")
    else
      current = @modal.find("li.filter.all")

    current.closest('ul').find('li').removeClass('active')
    current.addClass('active')

  _onFilter: (event) ->
    event.preventDefault()

    target = $(event.currentTarget)
    @objClass = target.data('obj-class')

    @showSelection = $(event.currentTarget).hasClass('selected-items')

    @_setFilterSelection()
    @_updateItems()

  _save: () ->
    # TODO: Use a callback instead of destinationField
    if @selected.length == 1 && @destinationField
      @destinationField.val(@_buildUrl(@selected)).focus()

    if @selected.length
      $('.mediabrowser-selected').html(@selected.join(', '))

    @close()

  _buildUrl: (id) ->
    "#{document.location.origin}/#{id}"

  _addItem: (element) ->
    element = $(element)
    element.addClass('active')

    id = element.closest('.mediabrowser-item').data('id')

    @selected.push(id)
    @selected = $.unique(@selected)
    @modal.find('.selected-total').html(@selected.length)

  _removeItem: (element) ->
    $(element).removeClass('active')
    @selected = @selected.filter (item) ->
      item != $(element).closest('.mediabrowser-item').data('id')
    @modal.find('.selected-total').html(@selected.length)

  _deselectAllItems: ->
    items = @modal.find('li.mediabrowser-item .select-item.active')
    items.each (_, element) ->
      $(element).removeClass('active')
    @selected = []

  _updateItems: (data) ->
    @_showLoading()

    data ||= {}
    data['selected'] = @selected
    data['query'] = @query
    data['obj_class'] = @objClass
    data['thumbnail_size'] = @_getThumbnailSize()

    url = '/mediabrowser'

    if @showSelection
      url = '/mediabrowser/selection'

    $.ajax
      url: url
      dataType: 'json'
      data: data
      success: (json) =>
        @modal.find('.editing-mediabrowser-items').html(json.content)
        if json.meta
          @modal.find('.result-total').html(json.meta.total)

  _initializeBindings: ->
    # TODO: should be moved to 3rd parties: open() method should receive
    # options, including a callback function to be called within save.
    $(document).on 'click', 'a.mediabrowser-open', (event) =>
      @allowedLength = $(event.currentTarget).data('mediabrowser-configuration-length')

      if @allowedLength == 1
        @destinationField = $(event.currentTarget).siblings("input[name=url]")

      @open()

    @modal.on 'keyup', 'input.search_field', (event) =>
      if event.keyCode == 13
        @query = $(event.target).val()
        @_updateItems()

    @modal.on 'click', 'li.mediabrowser-item', (event) =>
      unless $(event.target).hasClass('select-item')
        @_highlightItem($(event.currentTarget))

    @modal.on 'click', 'li.mediabrowser-item .select-item', (event) =>
      if @allowedLength == 1
        @_deselectAllItems()

      @_addItem(event.currentTarget)

    @modal.on 'click', 'li.mediabrowser-item .select-item.active', (event) =>
      @_removeItem(event.currentTarget)

    @modal.on 'click', '.mediabrowser-save', =>
      @_save()

    @modal.on 'click', '.mediabrowser-close', =>
      @close()

    @modal.on 'click', '.mediabrowser-reset', =>
      @_reset()

    @modal.on 'click', 'li.filter', (event) =>
      @_onFilter(event)

    @modal.on 'click', '.editing-button-view', (event) =>
      size = $(event.currentTarget).data('size')
      @_setThumbnailSize(size)

  _initializeUploader: ->
    MediabrowserUploader.init(@modal)

    MediabrowserUploader.onUploadStart = (obj) =>
      @_showLoading()

    MediabrowserUploader.onUploadFailure = (error) =>
      console.log('Mediabrowser Uploader Error:', error)

    MediabrowserUploader.onUploadSuccess = (objs) =>
      @_updateItems()

  _loadModalMarkup: ->
    @modal.html('')

    $.ajax
      url: '/mediabrowser/modal'
      dataType: 'json'
      success: (json) =>
        @modal.html(json.content)

        @_setFilterSelection()
        @_updateItems()

        MediabrowserInspector.init(@modal)
        @_initializeUploader()

  _showLoading: ->
    @modal.find('.editing-mediabrowser-items').html('
      <div class="editing-mediabrowser-loading">
        <i class="editing-icon editing-icon-refresh"></i>
      </div>')

  _getThumbnailSize: ->
    @_thumbnailSize || 'small'

  _setThumbnailSize: (size) ->
    @_thumbnailSize = size

    $('.editing-mediabrowser-thumbnails')
      .removeClass('small big large')
      .addClass(size)
    $('.editing-button-view').removeClass('active')
    $(".editing-button-view[data-size='#{size}']").addClass('active')

  _highlightItem: (element) ->
    @modal.find('li.mediabrowser-item.active').removeClass('active')
    element.addClass('active')

  init: ->
    unless $(@overlayBackgroundSelector).length
      @overlay = $('<div class="editing-overlay hide"></div>')
      $('body').append @overlay

    unless $(@modalSelector).length
      @modal = $('<div id="editing-mediabrowser" class="editing-mediabrowser hide"></div>')
      $('body').append @modal

    @_setDefaults()
    @_initializeBindings()

  _reset: () ->
    @_setDefaults()
    @_updateItems()
    @_setFilterSelection()
    @_updateSelected()
    MediabrowserInspector.close()

  close: () ->
    @_setDefaults()
    $(@overlayBackgroundSelector).toggleClass('show', false)
    $(@modalSelector).toggleClass('show', false)

  open: () ->
    # TODO: use future options to set defaults and remove _setDefaults from close()
    @_loadModalMarkup()
    $(@overlayBackgroundSelector).toggleClass('show', true)
    $(@modalSelector).toggleClass('show', true)
    $(@modalSelector).center()

$ ->
  Mediabrowser.init()

jQuery.fn.center = ->
  if @length == 1
    @css
      marginLeft: -this.innerWidth() / 2
      marginTop: -this.innerHeight() / 2
      left: '50%'

$(window).resize ->
  $('#editing-mediabrowser.show').center()
