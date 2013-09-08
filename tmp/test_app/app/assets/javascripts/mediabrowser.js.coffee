@Mediabrowser = do ->
  modal: '#ip-mediabrowser'
  inspector: '.inspector'
  loading: '.loading'
  selected: []
  query: ''

  init: ->
    unless $(@modal).length
      modalWindow = '<div id="ip-mediabrowser" class="modal hide"></div>'
      appContainment = $('body').append modalWindow

    @initializeBindings()

  save: () ->
    if @selected.length
      $('.mediabrowser-selected').html(@selected.join(', '))

    @close()

  updateSelected: () ->
    images = $('#ip-mediabrowser input.selected:checked')

    if images.length
      ids = $.map images, (image) ->
        image.id

    @selected = $.unique(@selected.concat(ids))

  close: () ->
    $(@modal).modal('hide')

  open: () ->
    $(@modal).modal('show')

  updateContent: (data) ->
    data ||= {}
    data['selected'] = @selected
    data['query'] = @query

    @showLoading()

    $.ajax(
      url: '/mediabrowser'
      dataType: 'json'
      data: data
      success: (json) =>
        $(@modal).html(json.content)

        @hideLoading()
    )

  initializeBindings: ->
    $(document).on 'change', '#ip-mediabrowser input.selected:checked', (event) =>
      @updateSelected()

    $(document).on 'keyup', '#ip-mediabrowser input.search', (event) =>
      if event.keyCode == 13
        @query = $(event.target).val()
        @updateContent()

    $(document).on 'click', '.mediabrowser-save', =>
      @save()

    $(document).on 'click', '.mediabrowser-close', =>
      @close()

    $(document).on 'click', 'a.mediabrowser', =>
      @updateContent()
      @open()

    $(document).on 'click', '.filter a', (event) =>
      event.preventDefault()

      objClass = $(event.currentTarget).data('obj-class')

      @updateContent
        obj_class: objClass

    $(document).on 'click', 'li.previous a, li.next a', (event) =>
      event.preventDefault()

      page = $(event.currentTarget).data('page')

      @updateContent
        page: page

    $(@modal).on 'click', 'tr.inspect', (event) =>
      unless $(event.target).is(':checkbox')
        element = $(event.currentTarget)
        id = element.data('id')

        @renderInspector(id)

    $(@modal).on 'click', 'a.inspector-close', (event) =>
      event.preventDefault()

      @closeInspector()

  highlightSelected: (element) ->
    @removeSelectionHighlight()
    element.addClass('selected')

  removeSelectionHighlight: ->
    $(@modal).find('tr.selected').removeClass('selected')

  showLoading: ->
    $(@loading).show()
    $(@modal).find('.content').hide()

  hideLoading: ->
    $(@loading).hide()
    $(@modal).find('.content').show()

  closeInspector: ->
    $(@inspector).html('')

  renderInspector: (id) ->
    data =
      id: id

    $.ajax(
        url: '/mediabrowser/edit'
        dataType: 'json'
        data: data
        success: (json) =>
          $(@modal).find(@inspector).html(json.content)
          infopark.editing.refresh($(@inspector))
      )

$ ->
  Mediabrowser.init()
