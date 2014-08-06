# Javascript for Admin/Efars/Index controller

$(document).on 'change', '.community-select', (e) ->
  window.location.href = $(@).attr('value')

