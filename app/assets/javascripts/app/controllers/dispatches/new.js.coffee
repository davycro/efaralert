class GeocoderResult extends Spine.Model
  @configure "GeocoderResult", "lat", "lng", 
    "formatted_address", "location_type", "marker"

  @loadGoogleResults: (results) ->
    @destroyAll()
    @addOne(result) for result in results
    @trigger 'refresh', @all()

  @addOne: (result) ->
    location = @create({
        lat: result.geometry.location.lat(),
        lng: result.geometry.location.lng(),
        formatted_address: result.formatted_address,
        location_type: result.geometry.location_type
      })
    location.setMarker(result)
    location.save()

  @bind 'destroy', (record) =>
    record.marker.setMap(null)

  setMarker: (result) ->
    @marker = new google.maps.Marker(position: result.geometry.location)

  reverseGeocode: ->
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {'latLng':@marker.getPosition()}, (results, status) =>
      if (status == google.maps.GeocoderStatus.OK)
        result = results[0]
        @formatted_address = result.formatted_address
        @location_type = result.geometry.location_type
        @save() 


class LocationSettlement extends Spine.Controller

  constructor: ->
    super
    @html 'settlement'


class LocationAddress extends Spine.Controller

  events:
    'submit [data-type=search-form]' : 'geocodeSearchInput'

  elements:
    '[data-type=search-input]' : 'searchInput'
    '[data-type=map]' : 'mapElement'
    '[data-type=sidebar-list]' : 'sidebarList'

  constructor: (selector) ->
    super()
    #
    # render elemetns
    @render()
    @renderMap()
    #
    # bind events
    GeocoderResult.bind 'refresh', (results) =>
      @sidebarList.html ''
      @addGeocoderResult(result) for result in results
      @selectGeocoderResult results[0]

  activate: ->
    super()
    @searchInput.focus()

  render: ->
    @html view('address_search')  

  renderMap: ->
    options = {
      zoom: 15
      center: new google.maps.LatLng(-33.9838663, 18.5552215)
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false  
    }
    mapEl = $(@mapElement)
    @map = new google.maps.Map(mapEl[0], options)

  geocodeSearchInput: (e) =>
    e.preventDefault()
    searchAddress = @searchInput.val() + ", Cape Town, South Africa"
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {'address': searchAddress}, (results, status) =>
      if (status == google.maps.GeocoderStatus.OK)
        GeocoderResult.loadGoogleResults(results)
      else
        console.log(status)

  addGeocoderResult: (result) ->
    result.marker.setMap(@map)
    @sidebarList.append view('sidebar_result_item')(result)


class LocationStack extends Spine.Stack
  controllers:
    settlement: LocationSettlement
    address: LocationAddress

  routes:
    '/settlement' : 'settlement'
    '/address' : 'address'

  default: 'address'

  constructor: ->
    @el = $('#location-stack')
    super


class LocationField extends Spine.Controller
  elements:
    '.modal' : 'modal'

  events:
    'click [data-type=show-modal]' : 'clickShowModal'
    'click [data-type=tab-button]' : 'clickTabButton'

  constructor: ->
    @el = $('[data-type=location-field]')
    super
    @append view('location_modal')
    @stack = new LocationStack()
    Spine.Route.setup()
    @modal.modal()

  clickShowModal: (e) =>
    e.preventDefault()
    @modal.modal()

  clickTabButton: (e) =>
    $(e.currentTarget).parent().siblings().removeClass('active')
    $(e.currentTarget).parent().addClass('active')


@module 'App.Controllers.Dispatches', ->

  class @New extends Spine.Controller

    constructor: (path) ->
      @el = $('#newDispatch')
      super()
      $('select').first().focus()
      @location_field = new LocationField()
      # @address_field = new AddressField()
      # AddressField.bind 'renderAddress', (result) =>
      #   $('input.landmarks').focus()
      #   $('button[type=submit]').removeAttr('disabled')

# Utilities and Shims
view = (name) ->
  JST["app/views/dispatches/#{name}"]
      