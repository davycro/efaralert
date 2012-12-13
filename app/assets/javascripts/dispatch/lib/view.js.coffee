Spine.Controller.include
  view: (name) ->
    JST["dispatch/views/#{name}"]

  redirectTo: (path) ->
    window.location = path