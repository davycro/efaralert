class App.Efar extends Spine.Model
  @configure "Efar", "street", "suburb", "postal_code", "city", "country", "lat", "lng", "first_names", "surname", "location_type", "training_score"
  @extend Spine.Model.Ajax
  @url: "/research/efars"

  constructor: ->
    super
    @gmarker = new google.maps.Marker(
      position: new google.maps.LatLng(@lat, @lng)
      icon: @setIcon()
    )
    @gwindow = new google.maps.InfoWindow(content: JST["research/views/efars/show"](this))

  setMap: (map) ->
    @gmarker.setMap(map)
    google.maps.event.addListener @gmarker, 'click', (event) =>
      @gwindow.open(map, @gmarker)

  setIcon: ->
    if @training_score >= 0.8
      return '/assets/firstaid.png'
    else
      return '/assets/firstaid_dark.png'


