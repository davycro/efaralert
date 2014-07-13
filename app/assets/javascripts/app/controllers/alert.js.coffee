@module 'App.Controllers.Alerts', ->
  class @New extends Spine.Controller

    constructor: ->
      @el = $('#new-alert')
      super()
      @renderMap()

    renderMap: ->
      @mapEl = $('#alert-location-mapper')
      options = {
        zoom: 11
        center: new google.maps.LatLng(-33.5429945,18.478363)
        mapTypeId: google.maps.MapTypeId.ROADMAP
        streetViewControl: false
        mapTypeControl: false  
      }
      @map = new google.maps.Map(@mapEl[0], options)  