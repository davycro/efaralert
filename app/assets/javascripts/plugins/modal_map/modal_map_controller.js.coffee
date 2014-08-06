@module 'App.Plugins', ->
  class @ModalMap extends Spine.Controller
    elements:
      '.modal' : 'modal'
      '.google-map' : 'mapElement'

    constructor: (selector) ->
      @el = $(selector)
      super
      @html JST["plugins/modal_map/view"]
      @loadData()
      @renderMap()
      @setMarkers()
      @modal.on 'shown', =>
        @resizeMap()

    loadData: ->
      @efars = $(@el).data('efars')

    renderMap: ->
      options = {
        zoom: 9
        center: new google.maps.LatLng(-33.9149861,18.6560594)
        mapTypeId: google.maps.MapTypeId.ROADMAP
        streetViewControl: false
        mapTypeControl: false  
      }
      mapEl = $(@mapElement)
      @map = new google.maps.Map(mapEl[0], options)

    resizeMap: ->
      google.maps.event.trigger(@map, 'resize')
      if @markers.length > 1
        @map.panTo @markers[0].getPosition()

    setMarkers: ->
      @markers = []
      @setMarker efar for efar in @efars

    setMarker: (efar) ->
      if (efar.lat? and efar.lng?)
        marker = new google.maps.Marker(
          position: new google.maps.LatLng(efar.lat, efar.lng)
          )
        marker.setMap(@map)
        google.maps.event.addListener marker, 'click', (event) =>
          @map.panTo marker.getPosition()
        @markers.push marker

    activate: ()->
      @modal.modal('show')


modal_maps = {}

$(document).on 'click', '[data-toggle="modal-map"]', (e) ->
  e.preventDefault()
  selector = $(@).attr('href')
  modal_maps[selector] or= new App.Plugins.ModalMap(selector)
  controller = modal_maps[selector]
  controller.activate()