class App.GeoLocation extends Spine.Model
  @configure "GeoLocation", "lat", "lng", 
    "formatted_address", "location_type", "marker"

  @reloadFromResults: (results) ->
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


class SearchMap extends Spine.Controller
  constructor: (elSelector) ->
    @el = $(elSelector)
    super()
    @renderMap()
    App.GeoLocation.bind 'refresh', (records) =>
      record.marker.setMap(@map) for record in records
      App.GeoLocation.trigger 'selectLocation', records[0]

    App.GeoLocation.bind 'selectLocation', (record) =>
      @map.panTo(record.marker.getPosition())

    App.LocationSearch.bind 'startSearch', =>
      @resize()

  renderMap: ->
    options = {
      zoom: 15
      center: new google.maps.LatLng(-33.9838663, 18.5552215)
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false  
    }
    @map = new google.maps.Map(@el[0], options)

  resize: ->
    google.maps.event.trigger(@map, 'resize') 


class MapSidebar extends Spine.Controller
  elements:
    'ul' : 'sidebarList'
  events:
    'click [data-type=GeoLocation]' : 'clickGeoLocation'

  constructor: (elSelector) ->
    @el = $(elSelector)
    super()
    App.GeoLocation.bind 'refresh', (records) =>
      @sidebarList.html ''
      @addRecord(record) for record in records
      App.GeoLocation.trigger 'selectLocation', records[0]

    App.GeoLocation.bind 'selectLocation', (record) =>
      $('li', @sidebarList).removeClass('active')
      $("[data-id=#{record.id}]", @sidebarList).parent().addClass('active')

    App.LocationSearch.bind 'cancelSearch', =>
      @sidebarList.html ''  

  addRecord: (record) ->
    @sidebarList.append @view('location_search/sidebar_list_item')(record)

  clickGeoLocation: (e) =>
    e.preventDefault()
    el = $(e.currentTarget)
    record = App.GeoLocation.find(el.data('id'))
    App.GeoLocation.trigger 'selectLocation', record


class SearchBar extends Spine.Controller
  elements:
    'input' : 'searchInput'
  events:
    'submit form' : 'submitSearch'

  constructor: (elSelector) ->
    @el = $(elSelector)
    super()

    App.LocationSearch.bind 'startSearch', =>
      @searchInput.val('')
      @searchInput.focus()

  submitSearch: (e) =>
    e.preventDefault()
    searchAddress = @searchInput.val() + ", Cape Town, South Africa"
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {'address': searchAddress}, (results, status) =>
      if (status == google.maps.GeocoderStatus.OK)
        App.GeoLocation.reloadFromResults(results)
      else
        console.log(status)


class App.LocationSearch extends Spine.Controller
  @extend Spine.Events

  events:
    'click [data-type=save]' : 'clickSaveButton'
    'click [data-type=cancel]' : 'clickCancelButton'

  elements:
    '.search-bar' : 'searchBarEl'
    '.search-map' : 'searchMapEl'
    '.map-sidebar' : 'mapSidebarEl'
    '.search-actions' : 'searchActionsEl'
    '.modal' : 'modalEl'
    '[data-type=save]' : 'saveButton'

  constructor: (elSelector) ->
    @el = $(elSelector)
    super()
    @html @view("location_search/modal")
    @searchBar = new SearchBar(@searchBarEl)
    @searchMap = new SearchMap(@searchMapEl)
    @mapSidebar = new MapSidebar(@mapSidebarEl)

    @modalEl.on 'shown', =>
      App.LocationSearch.trigger 'startSearch', @

    @selectedLocation = null

    App.GeoLocation.bind 'selectLocation', (record) =>
      @selectedLocation = record
      @saveButton.show()
      @saveButton.focus()      

  openModal: ->
    @modalEl.modal()

  clickSaveButton: (e) =>
    App.LocationSearch.trigger 'saveLocation', @selectedLocation
    @modalEl.modal('hide')  

  clickCancelButton: (e) =>
    @modalEl.modal('hide')
    App.LocationSearch.trigger 'cancelSearch'
    App.GeoLocation.destroyAll()

