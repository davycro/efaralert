class App.Efar extends Spine.Model
  @configure "Efar", "street", "suburb", "postal_code", "city", 
    "country", "lat", "lng", "first_names", "surname", 
    "location_type", "training_score", "community_center_id"
  @extend Spine.Model.Ajax
  @url: "/api/efars"
  
  @selectForCommunityCenter: (center) ->
    @select (efar) ->
      efar.community_center_id == center.id

  constructor: ->
    super
  #   @gmarker = new google.maps.Marker(
  #     position: new google.maps.LatLng(@lat, @lng)
  #     icon: @getIcon()
  #     visible: false
  #   )
  #   @gwindow = new google.maps.InfoWindow(content: JST["research/views/efars/show"](this))

  # getIcon: ->
  #   return App.MarkerIcon.getIconForId(@community_center_id)

  # setMap: (map) ->
  #   @gmarker.setMap(map)
  #   google.maps.event.addListener @gmarker, 'click', (event) =>
  #     @gwindow.open(map, @gmarker)
    


