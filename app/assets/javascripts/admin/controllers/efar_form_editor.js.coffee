class Locations extends Spine.Controller

  constructor: (elSelector) ->
    @el = $(elSelector)
    super()
    @index = 0
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


class App.EfarFormEditor extends Spine.Controller

  events:
    'click [data-type=create-new-contact-number-field]' : 'createNewContactNumberField'
    'click [data-type=add-location]' : 'launchLocationFinder'

  elements:
    '.efar-contact-number-fields' : 'efarContactNumberFields'
    '.locations-list' : 'locationsListEl'

  constructor: ->
    @el = $('.efar-form-editor')
    super()
    @numEfarContactNumbers = $(@efarContactNumberFields).data('length')
    @locationSearch = new App.LocationSearch("#location-search-app");
    @locations = new Locations(@locationsListEl)

  createNewContactNumberField: (e) =>
    e.preventDefault
    $(@efarContactNumberFields).append @view('efar_form_editor/contact_number_field')({index: @numEfarContactNumbers})
    $('[data-type=contactNumberInput]', @efarContactNumberFields).last().focus()
    @numEfarContactNumbers += 1

  launchLocationFinder: (e) =>
    e.preventDefault
    @locationSearch.openModal()


