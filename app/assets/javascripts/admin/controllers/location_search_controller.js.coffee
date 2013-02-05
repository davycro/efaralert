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
      @map.panTo(records[0].marker.getPosition())

  renderMap: ->
    options = {
      zoom: 15
      center: new google.maps.LatLng(-33.9838663, 18.5552215)
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false  
    }
    @map = new google.maps.Map(@el[0], options) 


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

  addRecord: (record) ->
    @sidebarList.append @view('location_search/sidebar_list_item')(record)

  clickGeoLocation: (e) =>
    e.preventDefault()
    el = $(e.currentTarget)
    record = App.GeoLocation.find(el.data('id'))
    console.log('click!')
    console.log(record)


class SearchBar extends Spine.Controller
  elements:
    'input' : 'searchInput'
  events:
    'submit form' : 'submitSearch'

  constructor: (elSelector) ->
    @el = $(elSelector)
    super()

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
  elements:
    '.search-bar' : 'searchBarEl'
    '.search-map' : 'searchMapEl'
    '.map-sidebar' : 'mapSidebarEl'
    '.modal' : 'modalEl'

  constructor: (elSelector) ->
    @el = $(elSelector)
    super()
    @html @view("location_search/modal")
    @modalEl.modal({keyboard: false})
    @searchBar = new SearchBar(@searchBarEl)
    @searchMap = new SearchMap(@searchMapEl)
    @mapSidebar = new MapSidebar(@mapSidebarEl)
