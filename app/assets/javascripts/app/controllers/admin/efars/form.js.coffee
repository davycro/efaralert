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

  @geocode: (searchStr) ->
    searchStr or= ""
    searchStr += ", Cape Town, South Africa"
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {'address': searchStr}, (results, status) =>
      if (status == google.maps.GeocoderStatus.OK)
        GeocoderResult.loadGoogleResults(results)
      else
        console.log(status)


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


class AddressSelector extends Spine.Controller
  @extend Spine.Events

  elements:
    '.modal' : 'modal'
    '[data-type=search-input]' : 'searchInput'
    '[data-type=map-sidebar]' : 'mapSidebar'
    '[data-type=map]' : 'mapElement'
    '[data-type=save]' : 'saveButton'

  events:
    'submit [data-type=search-form]' : 'submitSearchForm'
    'click [data-type=geocoder-result]' : 'clickResult'
    'click [data-type=cancel]' : 'clickCancelButton'
    'click [data-type=save]' : 'clickSaveButton'

  constructor: ->
    super

    #
    # bind events
    GeocoderResult.bind 'refresh', (results) =>
      @mapSidebar.html view('map_sidebar')(results)
      result.marker.setMap(@map) for result in results
      @selectGeocoderResult results[0]

  activate: ->
    super()
    @searchInput.focus()
    @resizeMap()
    if @searchInput.val() and @searchInput.val().length>0
      GeocoderResult.geocode @searchInput.val()

  render: ->
    @html view('address_selector')
    @renderMap()
    @modal.on 'shown', =>
      @activate()

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

  resizeMap: ->
    google.maps.event.trigger(@map, 'resize')

  selectGeocoderResult: (result) ->
    $('li', @mapSidebar).removeClass 'active'
    $("[data-id=#{result.id}]", @mapSidebar).parent().addClass('active')
    @map.panTo(result.marker.getPosition())
    @selectedGeocoderResult = result
    @saveButton.show()
    @saveButton.focus()

  #
  # outside actions

  open: (searchStr) ->
    if searchStr
      @searchInput.val(searchStr)
    @modal.modal()

  #
  # events
  submitSearchForm: (e) =>
    e.preventDefault()
    GeocoderResult.geocode @searchInput.val()

  clickSaveButton: (e) =>
    e.preventDefault()
    @selectedGeocoderResult.reverseGeocode()
    AddressSelector.trigger 'saveAddress', @selectedGeocoderResult
    @modal.modal 'hide'

  clickCancelButton: (e) =>
    e.preventDefault()
    @modal.modal 'hide'

  clickResult: (e) =>
    e.preventDefault()
    el = $(e.currentTarget)
    result = GeocoderResult.find(el.data('id'))
    @selectGeocoderResult result


@module 'App.Controllers.Admin.Efars', ->

  class @Form extends Spine.Controller
    events:
      'click [data-type=edit-address]': 'clickEditAddress'
      'click [data-type=search-address]': 'clickSearchAddress'
      'click [data-type=clear-address]' : 'clickClearAddress'
    elements:
      '[data-type=efar-address]' : 'efarAddress'

    constructor: (path) ->
      @el = $('#efarForm')
      super()
      # render efar address
      @efarAddress.html view('efar_address')(@efarAddress.data('efar'))
      @addressSelector = new AddressSelector()
      AddressSelector.bind 'saveAddress', (result) =>
        @efarAddress.html view('efar_address')(result)
      @append @addressSelector
      @addressSelector.render()

    #
    # events
    clickEditAddress: (e) =>
      e.preventDefault()
      searchStr = $('input[name=address]', @efarAddress).val()
      @addressSelector.open(searchStr)

    clickSearchAddress: (e) =>
      e.preventDefault()
      searchStr = $('input[name=address]', @efarAddress).val()
      @addressSelector.open(searchStr)

    clickClearAddress: (e) =>
      e.preventDefault()
      @efarAddress.html view('efar_address')({})

# Utilities and Shims
view = (name) ->
  JST["app/views/admin/efars/#{name}"]


