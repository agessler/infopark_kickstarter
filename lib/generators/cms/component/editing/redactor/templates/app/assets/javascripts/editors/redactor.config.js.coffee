$ ->
  timeout = undefined
  savedContent = undefined
  originalContent = ''

  saveAction = ->
    @getBox().addClass('saving')
    saveContents(@).done =>
      @.destroy()

  cancelAction = ->
    cancelEditing(@)

  autosaveAction = (editor) ->
    if timeout
      clearTimeout(timeout)

    timeout = setTimeout ( ->
      saveContents(editor)
    ), 3000

  undoAction = ->
    @execCommand('undo')

  redoAction = ->
    @execCommand('redo')

  redactorOptions = ->
    customButtonDefinition =
      saveButton:
        title: 'Save'
        callback: saveAction
      cancelButton:
        title: 'Cancel'
        callback: cancelAction
      undoButton:
        title: 'Undo'
        callback: undoAction
      redoButton:
        title: 'Redo'
        callback: redoAction

    return {} =
      buttonsCustom: customButtonDefinition,
      focus: true
      convertDivs: false
      linebreaks: true
      linkEmail: true
      buttons: ['saveButton', 'cancelButton',
        '|', 'undoButton', 'redoButton',
        '|', 'formatting',
        '|', 'bold', 'italic', 'deleted', 'underline',
        '|', 'unorderedlist', 'orderedlist',
        '|', 'table', 'link',
        '|', 'fontcolor', 'backcolor',
        '|', 'html'
      ]
      removeEmptyTags: false
      linebreaks: false

      initCallback: ->
        originalContent = @get()

      changeCallback: ->
        autosaveAction(@)

      blurCallback: ->
        saveContents(@)

      keyupCallback: (event) ->
        key = event.keyCode || event.which

        if key == 27
          cancelEditing(@)
        else
          autosaveAction(@)

      pasteAfterCallback: (html) ->
        autosaveAction(@)
        html

  saveContents = (editor) ->
    content = editor.get()

    if savedContent != content
      editor.$element.infopark('save', content).done ->
        savedContent = content
      .fail ->
        editor.getBox().removeClass('saving')

    else
      $.Deferred().resolve()

  cancelEditing = (editor) ->
    editor.set(originalContent)
    saveContents(editor)
    editor.destroy()

  htmlFields = (content, fieldType) ->
    content.find("[data-ip-field-type='html']")

  addOnclickRedactorHandlers = (content) ->
    htmlFields(content).on 'click', (event) ->
      event.preventDefault()
      cmsField = $(this)

      unless cmsField.hasClass('redactor_editor')
        cmsField.html(cmsField.infopark('content') || '')
        cmsField.redactor(redactorOptions())

  infopark.on 'editing', ->
    addOnclickRedactorHandlers($('body'))

  infopark.on 'new_content', (domElement) ->
    addOnclickRedactorHandlers($(domElement))
