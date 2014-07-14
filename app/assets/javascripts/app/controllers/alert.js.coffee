class Alert extends Spine.Model
  @configure "Alert", 
    "formatted_address", "lat", "lng", "location_type",
    "given_location", "landmarks", "incident_type"
  @extend Spine.Model.Ajax
  @url "/alerts"


class GeocoderResult extends Spine.Model
  @configure "GeocoderResult", "lat", "lng", 
    "formatted_address", "location_type", "geometry"

  @loadGoogleResults: (results) ->
    @destroyAll()
    @addOne(result) for result in results
    @trigger 'refresh', @all()

  @addOne: (result) ->
    location = @create({
        lat: result.geometry.location.lat(),
        lng: result.geometry.location.lng(),
        formatted_address: result.formatted_address,
        location_type: result.geometry.location_type,
        geometry: result.geometry
      })
    location.save()

  reverseGeocode: ->
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {'latLng':@marker.getPosition()}, (results, status) =>
      if (status == google.maps.GeocoderStatus.OK)
        result = results[0]
        @formatted_address = result.formatted_address
        @location_type = result.geometry.location_type
        @save()



@module 'App.Controllers.Alerts', ->
  class @New extends Spine.Controller
    @extend Spine.Events
    elements:
      'input[data-type=location]' : 'inputLocation'
      'input[data-type=suburb]' : 'inputSuburb'
      '[data-type=mapResults]' : 'mapResults'
      'input[name=incident_type]' : 'inputIncidentType'
      'input[name=landmarks]' : 'inputLandmarks'
    events:
      'click [data-type=findButton]' : 'clickFindButton'
      'click [data-type=geocoder-result]' : 'clickResult'
      'click [data-type=sendAlert]' : 'clickSendAlert'

    constructor: ->
      @el = $('#alerts-content')
      super()
      @renderMap()
      @confirmationModal = $('#confirmationModal').modal({show: false})

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

      GeocoderResult.bind 'refresh', (results) =>
        @mapResults.html view('map_sidebar')(results)
        @selectGeocoderResult results[0]


    clickFindButton: (e) =>
      e.preventDefault()
      searchStr = "#{@inputLocation.val()}, #{@inputSuburb.val()}, Western Cape, South Africa"
      geocoder = new google.maps.Geocoder()
      geocoder.geocode {'address': searchStr}, (results, status) =>
        if (status == google.maps.GeocoderStatus.OK)
          GeocoderResult.loadGoogleResults(results)
        else
          console.log(status)

    clickResult: (e) =>
      e.preventDefault()
      el = $(e.currentTarget)
      result = GeocoderResult.find(el.data('id'))
      @selectGeocoderResult result

    clickSendAlert: (e) =>
      e.preventDefault()
      # build the alert
      r = @selectedGeocoderResult
      @alert = new Alert({
        lat: @marker.position.lat()
        lng: @marker.position.lng()
        formatted_address: r.formatted_address
        location_type: r.location_type
        given_location: "#{@inputLocation.val()}, #{@inputSuburb.val()}"
        landmarks: @inputLandmarks.val()
        incident_type: (@inputIncidentType.val() or "Emergency")
      })
      console.log @alert
      @confirmationModal.html view('confirmation_modal')(@alert)
      @confirmationModal.modal 'show'


    selectGeocoderResult: (result) ->
      $('li', @mapResults).removeClass 'active'
      $("[data-id=#{result.id}]", @mapResults).parent().addClass('active')
      @marker.setPosition result.geometry.location
      @map.panTo @marker.getPosition()
      @selectedGeocoderResult = result

    setMarkerFromGeocoderResults: (results) ->
      result = results[0]
      @marker.setPosition result.geometry.location
      @map.panTo @marker.getPosition()

    # extracts alert information, initializes model
    buildAlert: ->




# Utilities and Shims
view = (name) ->
  JST["app/views/alerts/#{name}"]      

