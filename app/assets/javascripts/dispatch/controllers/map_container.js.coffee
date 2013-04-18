Config = Dispatch.Config


class Dispatch.MapContainer extends Spine.Controller
  className: 'dispatch-map google-map'

  constructor: ->
    super()
    # fills the bottom of the page
    $(window).resize =>
      $(@el).height $(window).height() - $(@el).offset().top - 20

  render: ->
    $(window).resize()
    lat = Config.suburb.lat
    lng = Config.suburb.lng
    options = {
      zoom: 15
      center: new google.maps.LatLng(lat, lng)
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false  
    }
    @map = new google.maps.Map(@el[0], options)
    Config.map = @map