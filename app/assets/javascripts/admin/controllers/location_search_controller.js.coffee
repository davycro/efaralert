class SearchResultsMap extends Spine.Controller
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


class SearchResultsSidebar extends Spine.Controller



class SearchResults extends Spine.Controller
  elements:
    '.google-map' : 'googleMapEl'

  constructor: ->
    super
    @html @view("location_search/search_results")
    @mapController = new SearchResultsMap(@googleMapEl)


class SearchBar extends Spine.Controller

  constructor: ->
    super
    @html @view("location_search/search_bar")    




class App.LocationSearch extends Spine.Controller
  constructor: (elSelector) ->
    @el = $(elSelector)
    super()
    @searchBar = new SearchBar()
    @searchResults = new SearchResults()
    @append @searchBar, @searchResults
