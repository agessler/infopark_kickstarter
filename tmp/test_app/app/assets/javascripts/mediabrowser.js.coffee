@Mediabrowser = do ->
  modal: '#ip-mediabrowser'

  init: ->
    unless $(@modal).length
      modalWindow = '<div id="ip-mediabrowser" class="modal hide"></div>'
      appContainment = $('body').append modalWindow

    @initializeBindings()

  close: () ->
    $(@modal).modal('hide')

  open: () ->
    $(@modal).modal('show')

  updateContent: () ->
    $.ajax(
      url: '/mediabrowser'
      dataType: 'json'
      success: (json) =>
        $(@modal).html(json.content)
    )

  # Events
  initializeBindings: ->
    $(document).on 'click', '.mediabrowser-close', =>
      @close()

    $(document).on 'click', 'a.mediabrowser', =>
      @updateContent()
      @open()

$ ->
  Mediabrowser.init()
