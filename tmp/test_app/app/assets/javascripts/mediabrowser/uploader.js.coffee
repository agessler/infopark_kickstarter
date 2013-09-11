class @MediabrowserUploader
  containmentSelector = '.modal-body'
  dropOverCssClass = 'uploader-drag-over'

  initializeBindings = ->
    @modal.on 'dragover', containmentSelector, (event) ->
      $(event.currentTarget).addClass(dropOverCssClass)
      false

    @modal.on 'dragleave', containmentSelector, (event) ->
      $(event.currentTarget).removeClass(dropOverCssClass)
      false

    @modal.on 'drop', containmentSelector, (event) =>
      $(event.currentTarget).removeClass(dropOverCssClass)
      onDrop.call(@, event)
      false

  onDrop = (event) ->
    dataTransfer = event.originalEvent.dataTransfer

    unless dataTransfer?
      return

    files = dataTransfer.files
    if files.length == 0
      return

    file = files[0]

    @onUploadStart(file)

    createImage(file).done (data) =>
      @onUploadSuccess(data)
    .fail (data) =>
      @onUploadFailure(data)

  randomResourceId = ->
    hex = Math.floor(Math.random() * Math.pow(16, 8)).toString(16)

    while (hex.length < 8)
      hex = "0" + hex

    hex


  createImage = (file) ->
    obj_name = file.name.replace(/[^a-z0-9_.$\-]/ig, '-')
    path = "_resources/#{randomResourceId()}/#{obj_name}"

    infopark.create_obj
      blob: file
      _path: path
      _obj_class: 'Image'

  constructor: (@modal) ->
    initializeBindings.call(@)

  onUploadStart: (file) ->
    # hook for 3rd parties

  onUploadFailure: (error) ->
    # hook for 3rd parties

  onUploadSuccess: (obj) ->
    # hook for 3rd parties