$ ->
  # Integrates a mediabrowser based editor for reference CMS attributes.

  infopark.on 'editing', ->
    $('body').on 'click', '[data-ip-field-type=reference]', (event) ->
      event.preventDefault()

      cmsField = $(event.currentTarget)
      selected = [cmsField.infopark('content')]

      # Open mediabrowser with current reference selected and restrict selection to one reference.
      Mediabrowser.open
        allowedLength: 1
        selection: selected

        onSave: (selection) =>
          onMediabrowserSave(selection, cmsField)

    # Save single reference when media browser calls "save".
    onMediabrowserSave = (selection, cmsField) ->
      cmsField.addClass('saving')

      value = selection[0] || null

      cmsField.infopark('save', value)
      .done ->
        cmsField.trigger('infopark_reload');
      .fail ->
        cmsField.removeClass('saving')

      true
