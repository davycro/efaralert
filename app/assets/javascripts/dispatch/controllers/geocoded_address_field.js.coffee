class App.GeocoderResult extends Spine.Model
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


class Search extends Spine.Controller
  elements:
    '.modal' : 'modalEl'
    '[data-type=search-input]' : 'searchInput'
    '[data-type=map]' : 'mapElement'
    '[data-type=sidebar-list]' : 'sidebarList'
    '[data-type=save]' : 'saveButton'

  events:
    'click [data-type=start-search]' : 'clickStartSearch'
    'focus [data-type=start-search]' : 'clickStartSearch'
    'submit [data-type=search-form]' : 'geocodeSearchInput'
    'click [data-type=save]' : 'clickSaveButton'
    'click [data-type=cancel]' : 'clickCancelButton'
    'click [data-type=geocoder-result]' : 'clickResult'

  constructor: ->
    super()
    @render()
    @renderMap()
    @modalEl.on 'shown', =>
      @startSearch()

    App.GeocoderResult.bind 'refresh', (results) =>
      @sidebarList.html ''
      @addGeocoderResult(result) for result in results
      @selectGeocoderResult results[0]

  render: ->
    @html @view('geocoded_address_field/search')

  clickStartSearch: (e) =>
    e.preventDefault()
    @modalEl.modal()

  startSearch: ->
    @searchInput.val ''
    @searchInput.focus()
    @resizeMap()

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
        App.GeocoderResult.loadGoogleResults(results)
      else
        console.log(status)

  addGeocoderResult: (result) ->
    result.marker.setMap(@map)  
    @sidebarList.append @view('geocoded_address_field/sidebar_result_item')(result)

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
    App.GeocodedAddressField.trigger 'renderAddress', @selectedGeocoderResult
    @modalEl.modal('hide')
    $('[data-type=start-search]').hide()

  clickCancelButton: (e) =>
    e.preventDefault()
    @modalEl.modal('hide')
    @sidebarList.html ''
    App.GeocoderResult.destroyAll()

  clickResult: (e) =>
    e.preventDefault()
    el = $(e.currentTarget)
    result = App.GeocoderResult.find(el.data('id'))
    @selectGeocoderResult result


class Show extends Spine.Controller

  constructor: (modelName) ->
    super()
    @modelName = modelName
    App.GeocodedAddressField.bind 'renderAddress', (result) =>
      @result = result
      @render(result)

    App.GeocoderResult.bind 'update', (result) =>
      if @result
        @render(result)

  render: (result) ->
    view_data = { result: result, modelName: @modelName }
    @html @view('geocoded_address_field/show')(view_data)


class App.GeocodedAddressField extends Spine.Controller
  @extend Spine.Events

  events:
    'click [data-type=edit-search]' : 'clickEditSearch'

  constructor: (elSelector) ->
    elSelector or= '[data-type=geocoded-address-field]'
    @el = $(elSelector)
    super()

    @show = new Show(@el.data('model-name'))
    @search = new Search

    @append @show, @search

  clickEditSearch: (e) =>
    e.preventDefault()
    @search.modalEl.modal()
