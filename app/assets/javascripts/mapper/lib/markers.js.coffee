class App.GoogleMapMarker extends Spine.Module
  @records : {}
  @extend(Spine.Events)

  @find: (id) ->
    record = @records[id]
    throw new Error('Unknown record') unless record
    record

  @all: ->
    arr = (record for id, record of @records)
    arr

  @map: ->
    App.GoogleMap.map

  @configure: (modelClass, options) ->
    options or= {}
    console.log("options: ", options)
    options['iconClass'] or= App.MarkerIcon
    @records = {}
    @iconClass = options['iconClass']
    @modelClass = modelClass
    @modelClass.bind 'refresh', (records) =>
      @records[r.id] = new @(r) for r in records
      @trigger 'refresh', @records

  @select: (callback) ->
    result = (record for id, record of @records when callback(record))
    result

  constructor: (record) ->
    @record  = record
    @visible = false
    @map     = @constructor.map()
    @id      = record.id
    @marker  = new google.maps.Marker(
        position : new google.maps.LatLng(@record.lat, @record.lng)
        icon     : @getIcon()
        visible  : @visible
      )
    @marker.setMap(@map)

  show: (options) ->
    options or= {}
    @marker.setVisible(true)
    @panTo() if options['pan']

  hide: ->
    @marker.setVisible(false)

  panTo: ->
    @map.panTo @marker.getPosition()

  toggleVisible: (options) ->
    options or= {}
    if @marker.getVisible()
      @hide(options)
    else
      @show(options)

  getIcon: ->
    @constructor.iconClass.getDefaultIcon()


class App.CommunityCenterMarker extends App.GoogleMapMarker
  @configure App.CommunityCenter

  constructor: ->
    super

  getIcon: ->
    App.MarkerIcon.getIconForId(@record.id)


class App.EmergencyMarker extends App.GoogleMapMarker
  @configure App.Emergency, { 'iconClass': App.MarkerIconSplat }

  @findActive: ->
    result = (record for id, record of @records when record.isActive)
    result

  @toggleActive: (id) ->
    marker = @find(id)
    if marker.isActive
      marker.deactivate()
    else
      marker.activate()

  constructor: (emergency) ->
    super
    @isActive = false
    @window = new google.maps.InfoWindow(content: 
      JST["mapper/views/emergencies/show"](emergency))
    google.maps.event.addListener @marker, 'click', (event) =>
      @activate()
    google.maps.event.addListener @window, 'closeclick', (event) =>
      @deactivate()

    @show()

  activate: ->
    @isActive = true
    @window.open(@map, @marker)
    @panTo()
    @showDispatchMessages()
    @constructor.trigger 'activate', @

  deactivate: ->
    @isActive = false
    @window.close()
    @hideDispatchMessages()
    @constructor.trigger 'deactivate', @

  hide: ->
    super
    @deactivate()

  hideDispatchMessages: ->
    m.hide() for m in @dispatchMessageMarkers()

  showDispatchMessages: ->
    m.show() for m in @dispatchMessageMarkers()

  dispatchMessageMarkers: ->
    App.DispatchMessageMarker.select (dispatchMessage) =>
      dispatchMessage.record.emergency_id == @record.id


class App.EfarMarker extends App.GoogleMapMarker
  @configure App.Efar

  constructor: (efar) ->
    super
    @window = new google.maps.InfoWindow(content: 
      JST["mapper/views/efars/show"](efar))
    google.maps.event.addListener @marker, 'click', (e) =>
      @window.open(@map, @marker)

  hide: ->
    super
    @window.close()

  getIcon: ->
    App.MarkerIcon.getIconForId(@record.community_center_id)


class App.DispatchMessageMarker extends App.GoogleMapMarker
  @configure App.DispatchMessage



