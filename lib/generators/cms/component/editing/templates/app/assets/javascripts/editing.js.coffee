jQuery ->
  $('a#edit-toggle').on 'click', ->
    if infopark.editing.is_active()
      infopark.editing.deactivate()
    else
      infopark.editing.activate()

  infopark.on 'new_content', ->
    cmsEditEnums = $('[data-ip-field-type=enum], [data-ip-field-type=multienum]')

    for cmsEditEnum in cmsEditEnums
      $(cmsEditEnum).on 'focusout', ->
        cmsEditEnum.infopark('save', $(cmsEditEnum).val())


    cmsEditDates = $('[data-ip-field-type=date]')

    for cmsEditDate in cmsEditDates
      dateField = $(cmsEditDate).find('input[type=text]')

      $(dateField).datepicker(format: 'yyyy-mm-dd').on 'hide', (event) ->
        date = event.date

        # Set date hour to 12 to work around complex time zone handling.
        date.setHours(12)

        $(cmsEditDate).infopark('save', date)


    cmsEditLinklists = $('[data-ip-field-type=linklist]')

    for cmsEditLinklist in cmsEditLinklists
      $(cmsEditLinklist).on 'focusout', ->
        titleInputs = $(cmsEditLinklist).find("[name='title[]']")
        urlInputs = $(cmsEditLinklist).find("[name='url[]']")
        values = []

        for i in [0..titleInputs.length - 1]
          values[i] = {'title': titleInputs[i].value, 'url': urlInputs[i].value}

        $(cmsEditLinklist).infopark('save', values)

    $(cmsEditLinklists).find('button').click ->
      template = $(cmsEditLinklists).data('fields-template')
      $(cmsEditLinklists).find('ul').append(template)
