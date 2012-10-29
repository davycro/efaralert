$ = jQuery.sub()

class App.MapController extends Spine.Controller
  elements:
    "#map" : "mapEl"
    "#legend .nav": "legendNav"
    "#legend .legend-key" : "legendKey"

  events:
    "click .legend-key": "clickLegendKey"

  constructor: ->
    super
    @html JST["research/views/efars/map"]
    @createMap()
    @renderCommCenterLabels()

  createMap: ->
    options = {
      zoom: 13
      center: new google.maps.LatLng(-33.9838663, 18.5552215)
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false
    }
    @map = new google.maps.Map(@mapEl[0], options) 

  renderCommCenterLabels: ->
    # First load Efars
    # After efars have been loaded, fetch the community centers
    App.CommCenter.bind 'refresh', (centers) =>
      @legendNav.append(JST["research/views/efars/comm_center_label"](center)) for center in centers
      $(".legend-key").click()

    App.Efar.bind 'refresh', (efars) =>
      efar.setMap(@map) for efar in efars
      App.CommCenter.fetch()
    App.Efar.fetch()

  clickLegendKey: (e) ->
    el = $(e.currentTarget)
    center = App.CommCenter.find el.data('id')
    efar.toggleVisible() for efar in center.efars
    el.toggleClass('active')