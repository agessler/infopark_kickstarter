@Mediabrowser = {}

@Mediabrowser = do ->
  modal: '#ip-mediabrowser'
  inspector: undefined
  loading: '.loading'
  selected: []
  query: ''

  onPageChange: (event) ->
    event.preventDefault()

    page = $(event.currentTarget).data('page')

    @updateContent
      page: page

  onFilter: (event) ->
    event.preventDefault()

    objClass = $(event.currentTarget).data('obj-class')

    @updateContent
      obj_class: objClass

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
    @inspector = undefined

  open: () ->
    $(@modal).modal('show')

    @updateContent()

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

        @inspector ||= new Mediabrowser.Inspector($(@modal))

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
      @open()

    $(document).on 'click', '.filter a', (event) =>
      @onFilter(event)

    $(document).on 'click', 'li.previous a, li.next a', (event) =>
      @onPageChange(event)

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

$ ->
  Mediabrowser.init()
