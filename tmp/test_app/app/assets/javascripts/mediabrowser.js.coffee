@Mediabrowser = do ->
  modalSelector: '#ip-mediabrowser'
  inspector: undefined
  loading: '.loading'
  selected: []
  query: ''

  _onPageChange: (event) ->
    event.preventDefault()

    page = $(event.currentTarget).data('page')

    @_updateContent
      page: page

  _onFilter: (event) ->
    event.preventDefault()

    objClass = $(event.currentTarget).data('obj-class')

    @_updateContent
      obj_class: objClass

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

  _updateContent: (data) ->
    data ||= {}
    data['selected'] = @selected
    data['query'] = @query

    @_showLoading()

    $.ajax
      url: '/mediabrowser'
      dataType: 'json'
      data: data
      success: (json) =>
        @modal.html(json.content)

        @_hideLoading()

  _initializeBindings: ->
    $(document).on 'change', '#ip-mediabrowser input.selected:checked', (event) =>
      @_updateSelected()

    $(document).on 'keyup', '#ip-mediabrowser input.search', (event) =>
      if event.keyCode == 13
        @query = $(event.target).val()
        @_updateContent()

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

    @_initializeBindings()
    @_initializeUploader()

    @inspector = MediabrowserInspector.init(@modal)

  close: () ->
    @modal.modal('hide')

  open: () ->
    @modal.modal('show')

    @_updateContent()

$ ->
  Mediabrowser.init()
