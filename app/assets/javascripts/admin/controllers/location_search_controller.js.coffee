class SearchMap extends Spine.Controller
  constructor: (elSelector) ->
    @el = $(elSelector)
    super()
    @renderMap()

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
        console.log(results)
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
