$ ->
  current_obj_path = $('body').data('current-obj-path')

  $('#main_nav > li').each ->
    self = $(this)
    nav_item_path = self.data('path')

    if current_obj_path.indexOf(nav_item_path) == 0
      self.addClass('active')