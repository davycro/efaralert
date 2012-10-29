class App.Efar extends Spine.Model
  @configure "Efar", "street", "suburb", "postal_code", "city", "country", "lat", "lng", "first_names", "surname", "location_type", "training_score", "community_center_id"
  @extend Spine.Model.Ajax
  @url: "/research/efars"
  
  @selectForCommCenter: (center) ->
    @select (efar) ->
      efar.community_center_id == center.id

  constructor: ->
    super
    @gmarker = new google.maps.Marker(
      position: new google.maps.LatLng(@lat, @lng)
      icon: @getIcon()
      visible: false
    )
    @gwindow = new google.maps.InfoWindow(content: JST["research/views/efars/show"](this))

  getIcon: ->
    icons = [ "/assets/firstaid.png", "/assets/firstaid_red.png" ]
    return icons[(@community_center_id%icons.length)]

  setMap: (map) ->
    @gmarker.setMap(map)
    google.maps.event.addListener @gmarker, 'click', (event) =>
      @gwindow.open(map, @gmarker)

  toggleVisible: ->
    if @gmarker.getVisible()
      @gmarker.setVisible(false)
    else
      @gmarker.setVisible(true)  
    


