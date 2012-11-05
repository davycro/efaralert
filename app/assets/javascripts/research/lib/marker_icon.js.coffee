Spine.Controller.include
  view: (name) ->
    JST["research/views/#{name}"]

class App.MarkerIcon

  @filenamePrefix = "/assets/markers/marker_"
  @filetype       = ".png"
  @activeColors   = ["orange", "blue", "green"]
  @inactiveColor  = "gray"
  @shape          = "drop"

  @iconPath: (color) ->
    "#{@filenamePrefix}#{@shape}_#{color}#{@filetype}"

  @getIconForId: (id) ->
    color = @activeColors[(id%@activeColors.length)]
    return @iconPath(color)

  @getDefaultIcon: ->
    return @iconPath("blue")

class App.MarkerIconSplat extends App.MarkerIcon
  @shape = "splat"
  @activeColors = "red"

  @getDefaultIcon: ->
    return @iconPath("red")


