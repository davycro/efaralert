class App.MarkerIcon

  @icons: [
    {
      path: "/assets/markers/marker_orange.png"
      cssClass: "marker-icon-orange" 
    },
    {
      path: "/assets/markers/marker_blue.png"
      cssClass: "marker-icon-blue" 
    },
    {
      path: "/assets/markers/marker_green.png"
      cssClass: "marker-icon-green" 
    }
  ]

  @getIconForId: (id) ->
    return @icons[(id%@icons.length)].path

  @getCssClassForId: (id) ->
    return @icons[(id%@icons.length)].cssClass
