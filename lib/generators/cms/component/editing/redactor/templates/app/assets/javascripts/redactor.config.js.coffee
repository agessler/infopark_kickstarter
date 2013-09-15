$ ->
  saveAction = (buttonName, buttonDom, buttonObject)->
    editor = this
    editor.getBox().addClass('saving')

    if !editor.opts.visual
      editor.toggle(true)

    value = editor.get()

    editor.$element.infopark('save', value)
    .done ->
      editor.destroy()
    .fail ->
      editor.getBox().removeClass('saving')



  cancelAction = (buttonName, buttonDom, buttonObject)->
    editor = this
    editor.set(editor.$element.infopark('content') || '')
    editor.destroy()


  redactorOptionsForType = (type)->
    defaultOptions =
      focus: true
      convertDivs: false
      linebreaks: true
      buttonsCustom:
        saveButton:
          title: 'Save'
          callback: saveAction
        cancelButton:
          title: 'Cancel'
          callback: cancelAction

    specialOptions = switch type
        when 'string'
          {
            buttons: ['saveButton', 'cancelButton']
            allowedTags: []
          }
        when 'html'
          {
            buttons: ['saveButton', 'cancelButton',
              '|', 'formatting',
              '|', 'bold', 'italic', 'deleted', 'underline',
              '|', 'unorderedlist', 'orderedlist',
              '|', 'table', 'link',
              '|', 'fontcolor', 'backcolor',
              '|', 'html'
            ]
            removeEmptyTags: false
            linebreaks: false
          }
        else
          {}

    return $.extend(defaultOptions, specialOptions)


  cmsFields = (content, fieldType)->
    content.find("[data-ip-field-type='#{fieldType}']")


  addOnclickRedactorHandlers = (content)->
    _.each ['string', 'html'], (fieldType)->
      _.each cmsFields(content, fieldType), (cmsField)->
        domElement = $(cmsField)
        redactorOptions = redactorOptionsForType(fieldType)

        if redactorOptions && !domElement.hasClass('ip_field_editable')
          domElement.addClass('ip_field_editable')
          domElement.on 'click', (e)->
            e.preventDefault()
            if !domElement.data('redactor')
              domElement.html(domElement.infopark('content') || '')
              domElement.redactor(redactorOptions)


  infopark.on 'editing', ->
    addOnclickRedactorHandlers($('body'))

  infopark.on 'new_content', (domElement)->
    addOnclickRedactorHandlers($(domElement))
