class App.MarkerIcon

  @icons: [
    "/assets/markers/marker_orange.png",
    "/assets/markers/marker_green.png",
    "/assets/markers/marker_blue.png"
  ]

  @getIconForId: (id) ->
    return @icons[(id%@icons.length)]