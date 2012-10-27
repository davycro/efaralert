class App.Efar extends Spine.Model
  @configure "Efar", "street", "suburb", "postal_code", "city", "country", "lat", "lng", "first_names", "surname", "location_type", "training_score"
  @extend Spine.Model.Ajax
  @url: "/research/efars"
  
  @selectActive: ->
    @select (efar) ->
      efar.training_score >= 0.8

  @selectInactive: ->
    @select (efar) ->
      efar.training_score < 0.8

  constructor: ->
    super
    @gmarker = new google.maps.Marker(
      position: new google.maps.LatLng(@lat, @lng)
      icon: @setIcon()
      visible: false
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

  toggleVisible: ->
    if @gmarker.getVisible()
      @gmarker.setVisible(false)
    else
      @gmarker.setVisible(true)  
    


