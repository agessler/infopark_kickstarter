@Mediabrowser = do ->
  modal: '#ip-mediabrowser'
  inspector: '.inspector'

  init: ->
    unless $(@modal).length
      modalWindow = '<div id="ip-mediabrowser" class="modal hide"></div>'
      appContainment = $('body').append modalWindow

    @initializeBindings()

  close: () ->
    $(@modal).modal('hide')

  open: () ->
    $(@modal).modal('show')

  updateContent: (data) ->
    data ||= {}

    $.ajax(
      url: '/mediabrowser'
      dataType: 'json'
      data: data
      success: (json) =>
        $(@modal).html(json.content)
    )

  initializeBindings: ->
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
