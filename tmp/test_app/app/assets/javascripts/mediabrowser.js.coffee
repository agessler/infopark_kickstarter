@Mediabrowser = do ->
  modal: '#ip-mediabrowser'
  inspector: '.inspector'
  loading: '.loading'
  selected: []

  init: ->
    unless $(@modal).length
      modalWindow = '<div id="ip-mediabrowser" class="modal hide"></div>'
      appContainment = $('body').append modalWindow

    @initializeBindings()

  save: () ->
    images = @selected

    if images.length
      $('.mediabrowser-selected-items').html(images.join(', '))

    @close()

  updateSelectedImages: () ->
    images = $('input.selected-images:checked')

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
    $(document).on 'change', '#ip-mediabrowser input.selected-images:checked', =>
      @updateSelectedImages()

    $(document).on 'click', '.mediabrowser-save', =>
      @save()

    $(document).on 'click', '.mediabrowser-close', =>
      @close()

    $(document).on 'click', 'a.mediabrowser', =>
      @updateContent()
      @open()

    $(document).on 'click', 'li.previous a, li.next a', (event) =>
      event.preventDefault()

      page = $(event.currentTarget).data('page')

      @updateContent
        page: page

    $(@modal).on 'click', 'a.inspect', (event) =>
      event.preventDefault()

      id = $(event.currentTarget).data('id')
      @renderInspector(id)

    $(@modal).on 'click', 'a.inspector-close', (event) =>
      event.preventDefault()

      @closeInspector()

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
