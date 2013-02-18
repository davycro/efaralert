class App.EfarLocation extends Spine.Model
  @configure "EfarLocation", "efar", "formatted_address", "lat", "lng"
  @extend Spine.Model.Ajax
  @url: "/admin/efar_locations"

  @bind 'refresh', (records) ->
    record.setMarker() for record in records

  setWindow: (windowContent) ->
    @window or= new google.maps.InfoWindow(content: windowContent)
    google.maps.event.addListener @marker, 'click', (event) =>
      @window.open(@map, @marker)
      @map.panTo @marker.getPosition()

  setMarker: ->
    @marker or= new google.maps.Marker(
        position: new google.maps.LatLng(@lat, @lng)
      )

  setMap: (map) ->
    @map = map
    @setMarker()
    @marker.setMap(@map)


class App.EfarLocationMapper extends Spine.Controller

  constructor: (selector) ->
    selector or= '#efar-location-mapper'
    @el = $(selector)
    super()
    @renderMap()

    App.EfarLocation.bind 'refresh', (records) =>
      @addOne(record) for record in records

    App.EfarLocation.fetch()
    

  addOne: (record) ->
    record.setMarker()
    record.setMap(@map)
    record.setWindow(@view("efar_location_mapper/info_window")(record))


  renderMap: ->
    options = {
      zoom: 10
      center: new google.maps.LatLng(-33.9838663, 18.5552215)
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false  
    }
    @map = new google.maps.Map(@el[0], options)


