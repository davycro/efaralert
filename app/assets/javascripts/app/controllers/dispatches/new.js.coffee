
#
#   MODELS
# ----------------

# model to hold search results

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

# township data

class Township extends Spine.Model
  @configure "Township", "name", "efars"
  @extend Spine.Model.Ajax
  @url: "/api/townships"


#
#   Controllers
# ----------------

# Settlement controllers

# controls the settlement selector form
class LocationSettlement extends Spine.Controller
  elements:
    'select' : 'select'
    'button[type=submit]' : 'submitButton'

  events:
    'change select' : 'changeSelect'
    'click button[type=submit]' : 'clickSubmitButton'

  constructor: ->
    super
    Township.bind 'refresh', (records) =>
      @render(records)
    Township.fetch()

  render: (records) ->
    view_data = { records: records }
    @html view('select_settlement_tab_pane')(view_data)

  activate: ->
    super
    @select.focus()

  clickSubmitButton: (e) =>
    e.preventDefault()
    record_id = @select.find(':selected').data('id')
    record = Township.find(record_id)
    LocationField.trigger 'addSettlement', record
    LocationField.trigger 'hide'

  changeSelect: (e) =>
    e.preventDefault()
    @submitButton.focus()    


# controls the display of a selected settlement
class ShowSettlement extends Spine.Controller

  constructor: (modelName) ->
    super
    @modelName = modelName
    LocationField.bind 'addSettlement', (record) =>
      @render(record)

  render: (record) ->
    view_data = { record: record, modelName: @modelName }
    @html view('show_settlement_location')(view_data)


# ADDRESS controllers

# controls the address and map tab
class LocationAddress extends Spine.Controller

  events:
    'submit [data-type=search-form]' : 'geocodeSearchInput'
    'click [data-type=save]' : 'clickSaveButton'
    'click [data-type=geocoder-result]' : 'clickResult'

  elements:
    '[data-type=search-input]' : 'searchInput'
    '[data-type=map]' : 'mapElement'
    '[data-type=sidebar-list]' : 'sidebarList'
    '[data-type=save]' : 'saveButton'

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
    @resizeMap()

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

  resizeMap: ->
    google.maps.event.trigger(@map, 'resize') 

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

  selectGeocoderResult: (result) ->
    $('li', @sidebarList).removeClass 'active'
    $("[data-id=#{result.id}]", @sidebarList).parent().addClass('active')
    @map.panTo(result.marker.getPosition())
    @selectedGeocoderResult = result
    @saveButton.show()
    @saveButton.focus()

  clickSaveButton: (e) =>
    e.preventDefault()
    @selectedGeocoderResult.reverseGeocode()
    LocationField.trigger 'addAddress', @selectedGeocoderResult
    LocationField.trigger 'hide'

  clickCancelButton: (e) =>
    e.preventDefault()
    LocationField.trigger 'cancel'

  clickResult: (e) =>
    e.preventDefault()
    el = $(e.currentTarget)
    result = GeocoderResult.find(el.data('id'))
    @selectGeocoderResult result


class ShowAddress extends Spine.Controller

  constructor: (modelName) ->
    super
    @modelName = modelName
    LocationField.bind 'addAddress', (result) =>
      @result = result
      @render(result)

    GeocoderResult.bind 'update', (result) =>
      if @result
        @render(result)

  render: (result) ->
    view_data = { result: result, modelName: @modelName }
    @html view('show_address_location')(view_data)


# modal controllers

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
  @extend Spine.Events

  elements:
    '.modal' : 'modal'
    'button[data-type=show-modal]' : 'showModalButton'

  events:
    'click [data-type=show-modal]' : 'clickShowModal'
    'click [data-type=tab-button]' : 'clickTabButton'
    'click [data-type=edit]' : 'clickEditButton'
    'click [data-type=cancel]' : 'clickCancelButton'

  constructor: ->
    @el = $('[data-type=location-field]')
    super
    #
    # add the show divs
    @show_address = new ShowAddress(@el.data('model-name'))
    @show_settlement = new ShowSettlement(@el.data('model-name'))
    @append @show_address, @show_settlement
    #
    # render modal box
    @append view('location_modal')
    #
    # setup the stack with two tabs
    @stack = new LocationStack()
    #
    # bind events
    @modal.on 'shown', =>
      if @stack.address.isActive()
        @stack.address.active()
      if @stack.settlement.isActive()
        @stack.settlement.active()
    #
    # add address
    LocationField.bind 'hide', (result) =>
      @showModalButton.hide()
      @modal.modal 'hide'
    #
    # activate routing
    Spine.Route.setup()

    @modal.modal()

  clickShowModal: (e) =>
    e.preventDefault()
    @modal.modal()

  clickTabButton: (e) =>
    $(e.currentTarget).parent().siblings().removeClass('active')
    $(e.currentTarget).parent().addClass('active')

  clickEditButton: (e) =>
    e.preventDefault()
    @modal.modal()

  clickCancelButton: (e) =>
    e.preventDefault()
    @modal.modal 'hide'


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
      