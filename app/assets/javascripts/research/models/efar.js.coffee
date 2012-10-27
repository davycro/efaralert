class App.Efar extends Spine.Model
  @configure "Efar", "street", "suburb", "postal_code", "city", "country", "lat", "lng", "first_names", "surname"
  @extend Spine.Model.Ajax
  @url: "/research/efars"

  constructor: ->
    super
    @gmarker = new google.maps.Marker(
      position: new google.maps.LatLng(@lat, @lng)
      icon: '/assets/firstaid.png'
    )
    @gwindow = new google.maps.InfoWindow(content: JST["research/views/efars/show"](this))

  setMap: (map) ->
    @gmarker.setMap(map)
    google.maps.event.addListener @gmarker, 'click', (event) =>
      @gwindow.open(map, @gmarker)


