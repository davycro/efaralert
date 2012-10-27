$ = jQuery.sub()

class App.EfarsController extends Spine.Controller
  elements:
    "#map" : "mapEl"

  events:
    "click .legend-key": "legendClick"

  constructor: ->
    super
    @html JST["research/views/efars/index"]
    @createMap()
    @placeExistingEfars()

  createMap: ->
    options = {
      zoom: 13
      center: new google.maps.LatLng(-33.9838663, 18.5552215)
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    @map = new google.maps.Map(@mapEl[0], options)

  placeExistingEfars: ->
    App.Efar.bind 'refresh', (efars) =>
      efar.setMap(@map) for efar in efars
    App.Efar.fetch()

  legendClick: (e) ->
    efar_type = $(e.currentTarget).data('efar-type')
    if efar_type == "active"
      @toggleActive()
    if efar_type == "inactive"
      @toggleInactive()

  toggleActive: ->
    efar.toggleVisible() for efar in App.Efar.selectActive()

  toggleInactive: ->
    efar.toggleVisible() for efar in App.Efar.selectInactive() 

