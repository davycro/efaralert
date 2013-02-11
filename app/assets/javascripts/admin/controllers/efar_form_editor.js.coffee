class Locations extends Spine.Controller

  constructor: (elSelector) ->
    @el = $(elSelector)
    super()
    @index = @el.data('length')
    App.LocationSearch.bind 'saveLocation', (location) =>
      @addLocation(location)

  addLocation: (location) ->
    viewData = {
      location: location,
      namePrefix: "efar[locations_attributes][#{@index}]",
      index: @index
    }
    @append @view("efar_form_editor/location_field")(viewData)
    @index += 1
    $('select', @el).last().focus()


class App.EfarFormEditor extends Spine.Controller

  events:
    'click [data-type=add-location]' : 'launchLocationFinder'

  elements:
    '.locations-list' : 'locationsListEl'

  constructor: ->
    @el = $('.efar-form-editor')
    super()
    @locationSearch = new App.LocationSearch("#location-search-app");
    @locations = new Locations(@locationsListEl)

  launchLocationFinder: (e) =>
    e.preventDefault
    @locationSearch.openModal()


