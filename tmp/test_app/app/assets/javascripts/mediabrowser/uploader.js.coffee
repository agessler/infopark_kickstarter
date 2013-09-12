@MediabrowserUploader = do ->
  dropZoneSelector: '.modal-body'
  dropOverCssClass: 'uploader-drag-over'
  mimeTypeMapping:
    'image/*': 'Image'
    'audio/*': 'Audio'
    'video/*': 'Video'
    'application/pdf': 'Pdf'

  _initializeBindings: ->
    @modal.on 'dragover', @dropZoneSelector, (event) =>
      $(event.currentTarget).addClass(@dropOverCssClass)
      event.preventDefault()

    @modal.on 'dragleave', @dropZoneSelector, (event) =>
      $(event.currentTarget).removeClass(@dropOverCssClass)
      event.preventDefault()

    @modal.on 'drop', @dropZoneSelector, (event) =>
      $(event.currentTarget).removeClass(@dropOverCssClass)
      @_onDrop(event)
      event.preventDefault()

  _objClassForMimeType: (mimeType) ->
    for mime, objClass of @mimeTypeMapping
      return objClass if mimeType.match(mime)

    undefined

  _processQueue: (queue, createdObjs, promise) ->
    promise.then (data) =>
      @onUploadSuccess(data)

    file = queue.pop()

    if file?
      @_createResource(file).then (obj) =>
        createdObjs.push(obj)
      .always =>
        @_processQueue(queue, createdObjs, promise)

      return promise
    else
      return promise.resolve(createdObjs)

  _onDrop: (event) ->
    dataTransfer = event.originalEvent.dataTransfer

    unless dataTransfer?
      return

    files = dataTransfer.files

    if files.length == 0
      return

    promise = $.Deferred()

    queue = for file in files
      file

    @onUploadStart(queue)
    @_processQueue(queue, [], promise)

    promise

  _randomResourceId: ->
    hex = Math.floor(Math.random() * Math.pow(16, 8)).toString(16)

    while (hex.length < 8)
      hex = '0' + hex

    hex

  _createResource: (file) ->
    objName = file.name.replace(/[^a-z0-9_.$\-]/ig, '-')
    path = "_resources/#{@_randomResourceId()}/#{objName}"

    infopark.create_obj
      blob: file
      _path: path
      _obj_class: @_objClassForMimeType(file.type)

  init: (@modal) ->
    @_initializeBindings()

  onUploadStart: (files) ->
    # hook for 3rd parties

  onUploadFailure: (error) ->
    # hook for 3rd parties

  onUploadSuccess: (objs) ->
    # hook for 3rd parties
