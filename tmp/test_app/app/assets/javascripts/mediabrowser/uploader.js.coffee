class @MediabrowserUploader
  containmentSelector = '.modal-body'

  initializeBindings = ->
    @modal.on 'dragover.image_upload', containmentSelector, (event) ->
      $(event.currentTarget).addClass('ip_editing_dragover')
      false

    @modal.on 'dragleave.image_upload', containmentSelector, (event) ->
      $(event.currentTarget).removeClass('ip_editing_dragover')
      false

    @modal.on 'drop.image_upload', containmentSelector, (event) =>
      $(event.currentTarget).removeClass('ip_editing_dragover')
      onDrop.call(@, event)
      false

  onDrop = (event) ->
    dataTransfer = event.originalEvent.dataTransfer

    unless dataTransfer?
      return false

    files = dataTransfer.files
    return if files.length == 0

    file = files[0]

    @onUploadStart(file)

    createImage(file).done (data) =>
      @onUploadSuccess(data)
    .fail (data) =>
      @onUploadFailure(data)

  createImage = (file) ->
    obj_name = file.name.replace(/[^a-z0-9_.$\-]/ig, '-')
    path = "_resources/#{infopark.random_hex()}/#{obj_name}"

    infopark.obj.create({blob: file, _path: path, _obj_class: 'Image'})

  constructor: (@modal) ->
    initializeBindings.call(@)

  onUploadStart: (file) ->
    # hook for 3rd parties

  onUploadFailure: (error) ->
    # hook for 3rd parties

  onUploadSuccess: (obj) ->
    console.log('created blob', obj, obj.id())
    console.log 'deleting prev. uploaded obj'
    obj.destroy()