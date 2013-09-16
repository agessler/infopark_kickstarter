$ ->
  ###
  # This file integrates a simple text input field to edit string attributes.
  ###

  infopark.on 'editing', ->
    template = ->
      $('<div class="string-editor">
         <input type="text" />
         </div>')

    getBox = (element) ->
      element.closest('.string-editor')

    editMarker = (cmsField) ->
      cmsField.closest('[data-ip-widget-obj-class]').find('.ip_editing_marker')

    disableEditMode = (box) ->
      cmsField = box.data('cmsField')

      cmsField.show()
      editMarker(cmsField).show()
      box.remove()

    keyUp = (event) ->
      key = event.keyCode || event.which

      switch key
        when 13 # Enter
          save(event)
        when 27 # Esc
          cancel(event)

    save = (event) ->
      inputField = $(event.currentTarget)
      content = inputField.val()
      box = getBox(inputField)
      cmsField = box.data('cmsField')

      box.addClass('saving')

      cmsField.infopark('save', content).done ->
        cmsField.html(content)
        disableEditMode(box)
      .fail ->
        box.removeClass('saving')

    cancel = (event) ->
      box = getBox($(event.currentTarget))

      disableEditMode(box)

    $('body').on 'click', '[data-ip-field-type=string]', (event) ->
      event.preventDefault()

      cmsField = $(this)

      template()
        .data('cmsField', cmsField)
        .insertAfter(cmsField)
        .find('input')
        .val(cmsField.infopark('content') || '')
        .focusout(save)
        .keyup(keyUp)
        .focus()

      cmsField.hide()
      editMarker(cmsField).hide()
