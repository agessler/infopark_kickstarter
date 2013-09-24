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
    @thumbnailSize = 'small'
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
    if @selected.length == 1 && @destinationField
      @destinationField.val(@_buildUrl(@selected))

    if @selected.length
      $('.mediabrowser-selected').html(@selected.join(', '))

    @close()

  _buildUrl: (id) ->
    "#{document.location.origin}/#{id}"

  _updateSelected: ->
    items = @modal.find('li.mediabrowser-item .select-item.active')

    if items.length
      ids = $.map items, (item) ->
        $(item).closest('.mediabrowser-item').data('id')

    @selected = $.unique(@selected.concat(ids || []))
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
    data['thumbnail_size'] = @thumbnailSize

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
    $(document).on 'keyup', '#editing-mediabrowser input.search_field', (event) =>
      if event.keyCode == 13
        @query = $(event.target).val()
        @_updateItems()

    $(document).on 'click', 'li.mediabrowser-item', (event) =>
      unless $(event.target).hasClass('select-item')
        @_highlightSelected($(event.currentTarget))

    $(document).on 'click', 'li.mediabrowser-item .select-item', (event) =>
      if @allowedLength == 1
        @_deselectAllItems()

      $(event.currentTarget).toggleClass('active')
      @_updateSelected()

    $(document).on 'click', 'li.mediabrowser-item .select-item.active', (event) =>
      @_removeItem(event.currentTarget)

    $(document).on 'click', '.mediabrowser-save', =>
      @_save()

    $(document).on 'click', '.mediabrowser-close', =>
      @close()

    $(document).on 'click', '.mediabrowser-reset', =>
      @_reset()

    $(document).on 'click', 'a.mediabrowser-open', (event) =>
      @allowedLength = $(event.currentTarget).data('mediabrowser-configuration-length')

      if @allowedLength == 1
        @destinationField = $(event.currentTarget).siblings("input[name=url]")

      @open()

    $(document).on 'click', 'li.filter', (event) =>
      @_onFilter(event)

    $(document).on 'click', '.editing-button-view', (event) =>
      @thumbnailSize = $(event.currentTarget).data('size')
      @_changeThumbnailSize()

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
        <i class="editing-icon">&#xF03D;</i>
      </div>')

  _changeThumbnailSize: ->
    size = @thumbnailSize
    $('.editing-mediabrowser-thumbnails')
      .removeClass('small big large')
      .addClass(size)
    $('.editing-button-view').removeClass('active')
    $(".editing-button-view[data-size='#{size}']").addClass('active')

  _removeSelectionHighlight: ->
    @modal.find('li.mediabrowser-item.active').removeClass('active')

  _highlightSelected: (element) ->
    @_removeSelectionHighlight()
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
    @_changeThumbnailSize()

  _reset: () ->
    @_setDefaults()
    @_updateItems()
    @_setFilterSelection()
    @_updateSelected()
    @_changeThumbnailSize()
    MediabrowserInspector.close()

  close: () ->
    @_setDefaults()
    $(@overlayBackgroundSelector).toggleClass('show', false)
    $(@modalSelector).toggleClass('show', false)

  open: () ->
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
