$ = jQuery.sub()

Marker = App.Marker

class App.MarkersController extends Spine.Controller
  elements:
    "#map" : "mapEl"
    ".marker" : "markerIcons"

  constructor: ->
    super
    @html JST["views/markers/index"]
    @createMap()
    @createMapOverlay()
    @makeIconsDraggable()
    @placeExistingMarkers()

  createMap: ->
    options = {
      zoom: 11
      center: new google.maps.LatLng(-33.96, 18.5)
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    @map = new google.maps.Map(@mapEl[0], options)

  createMapOverlay: ->
    @overlay = new google.maps.OverlayView()
    @overlay.draw = ->
    @overlay.setMap(@map)

  makeIconsDraggable: ->
    @markerIcons.draggable({
      helper: 'clone'
      containment: 'parent'
      stop: (event, ui) => @placeNewMarker(event, ui)
    })

  placeNewMarker: (event, ui) ->
    offset = @mapEl.position()
    x = event.pageX - offset.left
    y = event.pageY - offset.top
    point = new google.maps.Point(x,y)
    latlng = @overlay.getProjection().fromContainerPixelToLatLng(point)
    icon = ui.helper[0].src
    marker = Marker.create({
      latitude: latlng.lat()
      longitude: latlng.lng()
      icon: icon
    })
    marker.setMap(@map)

  placeExistingMarkers: ->
    Marker.bind 'refresh', (markers) =>
      marker.setMap(@map) for marker in markers
    Marker.fetch()
