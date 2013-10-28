jQuery.fn.pixels = (property) ->
  parseInt(@css(property).slice(0,-2), 10)
