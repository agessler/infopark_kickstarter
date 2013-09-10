@Mediabrowser = {}

class @MediabrowserGUI
  modalSelector = '#ip-mediabrowser'
  inspector = undefined
  loading = '.loading'
  selected = []
  query = ''

  onPageChange = (event) ->
    event.preventDefault()

    page = $(event.currentTarget).data('page')

    updateContent.call @,
      page: page

  onFilter = (event) ->
    event.preventDefault()

    objClass = $(event.currentTarget).data('obj-class')

    updateContent.call @,
      obj_class: objClass

  save = () ->
    if selected.length
      $('.mediabrowser-selected').html(selected.join(', '))

    @close()

  updateSelected = ->
    images = @modal.find('input.selected:checked')

    if images.length
      ids = $.map images, (image) ->
        image.id

    selected = $.unique(selected.concat(ids))

  updateContent = (data) ->
    data ||= {}
    data['selected'] = selected
    data['query'] = query

    showLoading.call(@)

    $.ajax
      url: '/mediabrowser'
      dataType: 'json'
      data: data
      success: (json) =>
        @modal.html(json.content)

        hideLoading.call(@)

  initializeBindings = ->
    $(document).on 'change', '#ip-mediabrowser input.selected:checked', (event) =>
      updateSelected.call(@)

    $(document).on 'keyup', '#ip-mediabrowser input.search', (event) =>
      if event.keyCode == 13
        query = $(event.target).val()
        updateContent()

    $(document).on 'click', '.mediabrowser-save', =>
      save.call(@)

    $(document).on 'click', '.mediabrowser-close', =>
      @close()

    $(document).on 'click', 'a.mediabrowser', =>
      @open()

    $(document).on 'click', '.filter a', (event) =>
      onFilter.call(@, event)

    $(document).on 'click', 'li.previous a, li.next a', (event) =>
      onPageChange.call(@, event)

  highlightSelected = (element) ->
    @removeSelectionHighlight()
    element.addClass('selected')

  removeSelectionHighlight = ->
    $(@modal).find('tr.selected').removeClass('selected')

  showLoading = ->
    $(loading).show()
    @modal.find('.content').hide()

  hideLoading = ->
    $(loading).hide()
    @modal.find('.content').show()

  constructor: ->
    unless $(modalSelector).length
      @modal = $('<div id="ip-mediabrowser" class="modal hide"></div>')
      appContainment = $('body').append @modal

    initializeBindings.call(@)

  close: () ->
    @modal.modal('hide')

  open: () ->
    @modal.modal('show')

    @inspector ||= new MediabrowserInspector(@modal)
    updateContent.call(@)

$ ->
  Mediabrowser.gui = new MediabrowserGUI()
