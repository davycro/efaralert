$ = jQuery.sub()

class App.MapController extends Spine.Controller
  elements:
    "#map" : "mapEl"

  events:
    "click .map-legend-key": "clickLegendKey"

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
      @mapEl.append JST["research/views/efars/map_legend"]({
        centers: centers
      })
      $('.map-legend-key:first').click()

    App.Efar.bind 'refresh', (efars) =>
      efar.setMap(@map) for efar in efars
      App.CommCenter.fetch()
    App.Efar.fetch()

  clickLegendKey: (e) ->
    el = $(e.currentTarget)
    center = App.CommCenter.find el.data('id')
    efar.toggleVisible() for efar in center.efars
    el.toggleClass('active')
    el.find('.default-icon').toggleClass('hide')
    el.find('.active-icon').toggleClass('hide')