$ ->
  saveAction = (buttonName, buttonDom, buttonObject) ->
    editor = @
    editor.getBox().addClass('saving')

    if !editor.opts.visual
      editor.toggle(true)

    value = editor.get()

    editor.$element.infopark('save', value)
    .done ->
      editor.destroy()
    .fail ->
      editor.getBox().removeClass('saving')

  cancelAction = (buttonName, buttonDom, buttonObject) ->
    editor = @
    editor.set(editor.$element.infopark('content') || '')
    editor.destroy()

  redactorOptions = () ->
    customButtonDefinition =
      saveButton:
        title: 'Save'
        callback: saveAction
      cancelButton:
        title: 'Cancel'
        callback: cancelAction

    return {} =
      buttonsCustom: customButtonDefinition,
      focus: true
      convertDivs: false
      linebreaks: true
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

  htmlFields = (content, fieldType) ->
    content.find("[data-ip-field-type='html']")

  addOnclickRedactorHandlers = (content) ->
    htmlFields(content).on 'click', (event) ->
      event.preventDefault()
      cmsField = $(this)

      unless cmsField.data('redactor')
        cmsField.html(cmsField.infopark('content') || '')
        cmsField.redactor(redactorOptions())

  infopark.on 'editing', ->
    addOnclickRedactorHandlers($('body'))

  infopark.on 'new_content', (domElement) ->
    addOnclickRedactorHandlers($(domElement))
