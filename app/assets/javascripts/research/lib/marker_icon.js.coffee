Spine.Controller.include
  view: (name) ->
    JST["research/views/#{name}"]

class App.MarkerDropIcon

  @filenamePrefix = "/assets/markers/marker_drop_"
  @filetype       = ".png"
  @activeColors   = ["orange", "blue", "green"]
  @inactiveColor  = "gray"

  @iconPath: (color) ->
    "#{@filenamePrefix}#{color}#{@filetype}"

  @getIconForId: (id) ->
    color = @activeColors[(id%@activeColors.length)]
    return @iconPath(color)

  @getDefaultIcon: ->
    return @iconPath("blue")