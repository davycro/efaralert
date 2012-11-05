class App.GoogleMapMarker extends Spine.Module
  @records = {}

  @find: (id) ->
    record = @records[id]
    throw new Error('Unknown record') unless record
    record

  @all: ->
    arr = (record for id, record of @records)
    arr

  constructor: (record) ->
    @record = record
    @visible = false
    @map = App.GoogleMap.map
    

class App.CommunityCenterMarker extends App.GoogleMapMarker


class App.EmergencyMarker extends Spine.Module
  @records = {}

  App.Emergency.bind 'refresh', (emergencies) =>
    @records[em.id] = new @(em) for em in emergencies

  @find: (id) ->
    record = @records[id]
    throw new Error('Unknown record') unless record
    record

  @all: ->
    arr = (record for id, record of @records)
    arr

  constructor: (emergency) ->
    @record  = emergency
    @visible = false
    @map     = App.GoogleMap.map
    @marker  = new google.maps.Marker(
      position: new google.maps.LatLng(@record.lat, @record.lng)
      icon: "/assets/markers/marker_splat_red.png"
      visible: @visible
    )
    @marker.setMap(@map)

  show: ->
    @marker.setVisible(true)
    m.show() for m in @efarsMarkers()

  hide: ->
    @marker.setVisible(false)
    m.hide() for m in @efarsMarkers()

  toggleVisible: (options) ->
    options or= {}
    if @marker.getVisible()
      @marker.setVisible(false)
    else
      @marker.setVisible(true)
      @panTo() if options['pan']
    m.toggleVisible() for m in @efarsMarkers()

  panTo: ->
    @map.panTo @marker.getPosition()

  efarsMarkers: ->
    App.EfarMarker.select (efarMarker) =>
      efarMarker.id in @record.efar_ids


class App.EfarMarker
  @records = {}

  @select: (callback) ->
    result = (record for id, record of @records when callback(record))
    result

  @all: ->
    arr = (record for id, record of @records)
    arr

  App.Efar.bind 'refresh', (efars) =>
    @records[efar.id] = new @(efar) for efar in efars

  constructor: (efar) ->
    @record  = efar
    @visible = false
    @map     = App.GoogleMap.map
    @id      = efar.id
    @marker  = new google.maps.Marker(
        position: new google.maps.LatLng(@record.lat, @record.lng)
        icon: "/assets/markers/marker_drop_blue.png"
        visible: @visible
      )
    @marker.setMap(@map)

  toggleVisible: (options) ->
    options or= {}
    if @marker.getVisible()
      @marker.setVisible(false)
    else
      @marker.setVisible(true)
      @panTo() if options['pan']

  show: ->
    @marker.setVisible(true)

  hide: ->
    @marker.setVisible(false)

  panTo: ->
    @map.panTo @marker.getPosition()
