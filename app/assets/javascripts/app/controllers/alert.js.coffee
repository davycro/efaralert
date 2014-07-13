@module 'App.Controllers.Alerts', ->
  class @New extends Spine.Controller
    elements:
      'input[data-type=location]' : 'inputLocation'
      'input[data-type=suburb]' : 'inputSuburb'
    events:
      'click [data-type=findButton]' : 'clickFindButton'

    constructor: ->
      @el = $('#new-alert')
      super()
      @renderMap()

    renderMap: ->
      @mapEl = $('#alert-location-mapper')
      @centerLatLng = new google.maps.LatLng(-33.5429945,18.478363)
      options = {
        zoom: 13
        center: @centerLatLng 
        mapTypeId: google.maps.MapTypeId.ROADMAP
        streetViewControl: false
        mapTypeControl: false  
      }
      @map = new google.maps.Map(@mapEl[0], options)
      @marker = new google.maps.Marker({
        position: @centerLatLng
        map: @map
        draggable: true
      })
      google.maps.event.addListener @marker,'dragend', =>
        @map.panTo @marker.getPosition()


    clickFindButton: (e) =>
      e.preventDefault()
      searchStr = "#{@inputLocation.val()}, #{@inputSuburb.val()}, Western Cape, South Africa"
      geocoder = new google.maps.Geocoder()
      geocoder.geocode {'address': searchStr}, (results, status) =>
        if (status == google.maps.GeocoderStatus.OK)
          @setMarkerFromGeocoderResults(results)
        else
          console.log(status)

    setMarkerFromGeocoderResults: (results) ->
      result = results[0]
      @marker.setPosition result.geometry.location
      @map.panTo @marker.getPosition()
      # @marker = 


