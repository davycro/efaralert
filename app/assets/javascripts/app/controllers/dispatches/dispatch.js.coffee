# # # # # # # # # # # # # # # # # # # # # #
# Models
# # # # # # # # # # # # # # # # # # # # # # 

class Efar extends Spine.Model
  @configure "Efar", "formatted_address", "lat", "lng", "full_name"
  @extend Spine.Model.Ajax
  @url: "/efars"

  @bind 'refresh', (records) ->
    record.setMarker() for record in records

  setMarker: ->
    @marker or= new google.maps.Marker(
        position: new google.maps.LatLng(@lat, @lng)
        icon: '/assets/markers/marker_circle_blue.png'
      )

  setMap: (map) ->
    @map = map
    @setMarker()
    @marker.setMap(@map)


class Dispatch extends Spine.Model
  @configure "Dispatch", "formatted_address", "lat", "lng", 
    "location_type", "input_address", "emergency_category",
    "landmarks", "message_stats"
  @extend Spine.Model.Ajax
  @url: "/dispatches"

  constructor: (atts) ->
    super(atts)
    @marker = new google.maps.Marker()

  validate: ->
    return "You must enter a street address" unless @input_address
    return "You must enter a landmark" unless @landmarks

  geocodeAndSave: () ->
    return false unless @input_address
    @geocoder or= new google.maps.Geocoder()
    addressStr = "#{@input_address}, #{Config.suburb.name}, Cape Town, South Africa"
    @geocoder.geocode {'address': addressStr}, (results, status) =>
      if (status == google.maps.GeocoderStatus.OK)
        result = results[0] # pick the first one
        @lat = result.geometry.location.lat()
        @lng = result.geometry.location.lng()
        @formatted_address = result.formatted_address
        @location_type = result.geometry.location_type
        Messenger.post "Sending Dispatch"
        @save({done: ->
          Messenger.flash("Dispatch Sent! #{@message_stats.sent} people alerted")
          google.maps.event.trigger @marker, 'click'
        })
      else
        Messenger.flashError "Could not find address."
        console.log(status)


# # # # # # # # # # # # # # # # # # # # # #
# Controllers
# # # # # # # # # # # # # # # # # # # # # # 

class MapField extends Spine.Controller
  className: 'dispatch-map google-map'

  constructor: ->
    super()
    # fills the bottom of the page
    $(window).resize =>
      $(@el).height $(window).height() - $(@el).offset().top - 20

  renderMap: ->
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


class EfarsMapper

  constructor: () ->
    @map = Config.map

    Efar.bind 'refresh', (records) =>
      @addOne(record) for record in records
    Efar.fetch()

  addOne: (record) ->
    record.setMarker()
    record.setMap(@map)


class Dispatches

  constructor: () ->
    @map = Config.map

    Dispatch.bind 'refresh', (records) =>
      @addOne(record) for record in records

    Dispatch.bind 'create', (record) =>
      @addOne(record)

    Dispatch.fetch()

    @window = new google.maps.InfoWindow()
    @circle = new google.maps.Circle({radius: 300, map: @map, strokeWeight: 1})

  addOne: (record) ->
    record.marker.setOptions({
      position: new google.maps.LatLng(record.lat, record.lng)
      icon: '/assets/markers/marker_triangle_red.png'
      map: @map
      visible: true
    })
    google.maps.event.addListener record.marker, 'click', (event) =>
      content = view('dispatchInfoWindow')(record)
      @window.setContent(content)
      @window.open(@map, record.marker)
      @circle.setOptions({
        center: record.marker.getPosition()
        visible: true
      })
      @map.panTo record.marker.getPosition()
    google.maps.event.addListener @window, 'closeclick', (event) =>
      @circle.setOptions({visible: false})

class Topbar extends Spine.Controller
  events:
    'submit form' : 'submitForm'
  elements:
    'form' : 'form'
    '.alert' : 'alert'
    'button[type=submit]' : 'submitButton'

  constructor: ->
    super()
    @render()

  render: ->
    @html view('topbar')({emergencyCategories: Config.emergencyCategories})

  submitForm: (e) =>
    e.preventDefault()
    dispatch = Dispatch.fromForm(@form)
    msg = dispatch.validate()
    if msg
      Messenger.error "<strong>Error</strong> #{msg}"
    else
      dispatch.geocodeAndSave()
      $(@form)[0].reset()


class Config extends Spine.Module


@module 'App.Controllers', ->
  class @Dispatch extends Spine.Controller
    constructor: ->
      @el = $('#dispatchApp')
      super()
      Config.suburb = @el.data('suburb')
      Config.emergencyCategories = @el.data('dispatch-categories')
      @topbar = new Topbar()
      @mapField = new MapField()
      @append @topbar, @mapField
      @mapField.renderMap()
      @efarsMapper = new EfarsMapper()
      @dispatches = new Dispatches()

view = (name) ->
  JST["app/views/dispatch/#{name}"]

Messenger = App.Messenger