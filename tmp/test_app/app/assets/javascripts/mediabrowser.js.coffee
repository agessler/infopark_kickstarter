@Mediabrowser = do ->
  modalSelector: '#ip-mediabrowser'
  loading: '.loading'
  _setDefaults: ->
    @selected = []
    @query = ''
    @objClass = 'Image'

  _onPageChange: (event) ->
    event.preventDefault()

    page = $(event.currentTarget).data('page')

    @_updateItems
      page: page

  _setFilterSelection: () ->
    target = @modal.find(".filter a[data-obj-class='#{@objClass}']")

    target.closest('ul').find('li').removeClass('active')
    target.closest('li').addClass('active')

  _onFilter: (event) ->
    event.preventDefault()

    target = $(event.currentTarget)
    @objClass = target.data('obj-class')

    @_setFilterSelection()
    @_updateItems()

  _save: () ->
    if @selected.length
      $('.mediabrowser-selected').html(@selected.join(', '))

    @close()

  _updateSelected: ->
    images = @modal.find('input.selected:checked')

    if images.length
      ids = $.map images, (image) ->
        image.id

    @selected = $.unique(@selected.concat(ids))

  _updateItems: (data) ->
    @_showLoading()

    data ||= {}
    data['selected'] = @selected
    data['query'] = @query
    data['obj_class'] = @objClass

    $.ajax
      url: '/mediabrowser/items'
      dataType: 'json'
      data: data
      success: (json) =>
        @modal.find('.items').html(json.content)

        @_hideLoading()

  _initializeBindings: ->
    $(document).on 'change', '#ip-mediabrowser input.selected:checked', (event) =>
      @_updateSelected()

    $(document).on 'keyup', '#ip-mediabrowser input.search', (event) =>
      if event.keyCode == 13
        @query = $(event.target).val()
        @_updateItems()

    $(document).on 'click', '.mediabrowser-save', =>
      @_save()

    $(document).on 'click', '.mediabrowser-close', =>
      @close()

    $(document).on 'click', 'a.mediabrowser', =>
      @open()

    $(document).on 'click', '.filter a', (event) =>
      @_onFilter(event)

    $(document).on 'click', 'li.previous a, li.next a', (event) =>
      @_onPageChange(event)

  _initializeUploader: ->
    MediabrowserUploader.init(@modal)

    MediabrowserUploader.onUploadStart = (obj) =>
      @_showLoading()

    MediabrowserUploader.onUploadFailure = (error) =>
      console.log('Mediabrowser Uploader Error:', error)

    MediabrowserUploader.onUploadSuccess = (obj) =>
      @_updateContent()

  _highlightSelected: (element) ->
    @_removeSelectionHighlight()
    element.addClass('selected')

  _loadModalMarkup: ->
    @modal.html('')

    $.ajax
      url: '/mediabrowser'
      dataType: 'json'
      success: (json) =>
        @modal.html(json.content)

        @_setFilterSelection()
        @_updateItems()

        MediabrowserInspector.init(@modal)
        @_initializeUploader()

  _removeSelectionHighlight: ->
    @modal.find('tr.selected').removeClass('selected')

  _showLoading: ->
    $(@loading).show()
    @modal.find('.content').hide()

  _hideLoading: ->
    $(@loading).hide()
    @modal.find('.content').show()

  init: ->
    unless $(@modalSelector).length
      @modal = $('<div id="ip-mediabrowser" class="modal hide"></div>')
      appContainment = $('body').append @modal

    @_setDefaults()
    @_initializeBindings()

  close: () ->
    @_setDefaults()
    @modal.modal('hide')

  open: () ->
    @_loadModalMarkup()
    @modal.modal('show')


$ ->
  Mediabrowser.init()
