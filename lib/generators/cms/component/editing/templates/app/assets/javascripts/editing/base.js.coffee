$ ->
  # The "editing" event is only fired, when an editable working copy is selected. The callback
  # allows different styling based on whether the published or an editable working copy is selected.

  infopark.on 'editing', () ->
    $('body').addClass('ip_editable_workspace')


  # Activate or deactivate in-place editing.
  #
  # Click on the pen marker to activate in-place editing,
  # click on the menu item 'Deactivate in-place editing' to deactivate it.

  $('a#edit-toggle').on 'click', () ->
    if infopark.editing.is_active()
      infopark.editing.deactivate()
    else
      infopark.editing.activate()


  # Define editor behavior for enum and multienum attributes.

  infopark.on 'new_content', () ->
    cmsEditEnums = $('[data-ip-field-type=enum], [data-ip-field-type=multienum]')

    for cmsEditEnum in cmsEditEnums
      $(cmsEditEnum).on 'focusout', ->
        element = $(@)

        element.infopark('save', element.val())


  # Define editor behavior for date attributes.

  infopark.on 'new_content', () ->
    cmsEditDates = $('[data-ip-field-type=date]')

    for cmsEditDate in cmsEditDates
      dateField = $(cmsEditDate).find('input[type=text]')

      $(dateField).datepicker(format: 'yyyy-mm-dd').on 'hide', (event) ->
        date = event.date

        # Set date hour to 12 to work around complex time zone handling.
        date.setHours(12)

        cmsField = $(@).closest('[data-ip-field-type=date]')
        cmsField.infopark('save', date)

