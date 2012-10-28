$ = jQuery.sub()

class App.EfarsController extends Spine.Controller
  elements:
    "#map" : "mapEl"
    "#legend .nav" : "legendNav"

  events:
    "click .legend-key": "legendClick"

  constructor: ->
    super
    @html JST["research/views/efars/index"]
    @createMap()
    @placeExistingEfars()
    @placeLegend()

  createMap: ->
    options = {
      zoom: 13
      center: new google.maps.LatLng(-33.9838663, 18.5552215)
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false
    }
    @map = new google.maps.Map(@mapEl[0], options)

  placeExistingEfars: ->
    App.Efar.bind 'refresh', (efars) =>
      efar.setMap(@map) for efar in efars
    App.Efar.fetch()

  placeLegend: ->
    App.Efar.bind 'refresh', =>
      @legendNav.append JST["research/views/efars/legend-key"]({
          efar_type: "certified"
          count: App.Efar.selectActive().length
          key_label: "Certified EFARs"
          active: true 
        })
      @toggleActive()

      @legendNav.append JST["research/views/efars/legend-key"]({
          efar_type: "failed"
          count: App.Efar.selectInactive().length
          key_label: "Failed course" 
        })

  legendClick: (e) ->
    efar_type = $(e.currentTarget).data('efar-type')
    $(e.currentTarget).toggleClass('active')
    if efar_type == "certified"
      @toggleActive()
    if efar_type == "failed"
      @toggleInactive()

  toggleActive: ->
    efar.toggleVisible() for efar in App.Efar.selectActive()

  toggleInactive: ->
    efar.toggleVisible() for efar in App.Efar.selectInactive() 

