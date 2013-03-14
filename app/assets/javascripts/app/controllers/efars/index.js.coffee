class Efar extends Spine.Model
  @configure "Efar", "formatted_address", "lat", "lng", "full_name"
  @extend Spine.Model.Ajax
  @url: "/efars"

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


@module 'App.Controllers.Efars', ->

  class @Index extends Spine.Controller
    elements:
      '#efar-location-mapper' : 'mapEl'
    events:
      'click [data-type=pan-map]' : 'clickPanMapLink'

    constructor: (selector) ->
      @el = $('#efars-index')
      super()
      @view = JST["app/views/admin/efars/map_window"]
      @renderMap()

      Efar.bind 'refresh', (records) =>
        @addOne(record) for record in records

      Efar.fetch()

    addOne: (record) ->
      record.setMarker()
      record.setMap(@map)
      record.setWindow(@view(record))

    renderMap: ->
      options = {
        zoom: 10
        center: new google.maps.LatLng(-33.9838663, 18.5552215)
        mapTypeId: google.maps.MapTypeId.ROADMAP
        streetViewControl: false
        mapTypeControl: false  
      }
      @map = new google.maps.Map(@mapEl[0], options)

    clickPanMapLink: (e) =>
      e.preventDefault()
      el = $(e.currentTarget)
      latLng = new google.maps.LatLng($(el).data('lat'), $(el).data('lng'))
      @map.panTo(latLng)
      @map.setZoom($(el).data('zoom'))




