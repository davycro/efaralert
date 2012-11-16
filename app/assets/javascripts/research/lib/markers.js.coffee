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
      JST["research/views/emergencies/show"](emergency))
    google.maps.event.addListener @marker, 'click', (event) =>
      @activate()
    google.maps.event.addListener @window, 'closeclick', (event) =>
      @deactivate()

    @show()

  activate: ->
    @isActive = true
    @window.open(@map, @marker)
    @panTo()
    @showEfars()
    @constructor.trigger 'activate', @

  deactivate: ->
    @isActive = false
    @window.close()
    @hideEfars()
    @constructor.trigger 'deactivate', @

  hide: ->
    super
    @deactivate()

  hideEfars: ->
    m.hide() for m in @efarsMarkers()

  showEfars: ->
    m.show() for m in @efarsMarkers()

  efarsMarkers: ->
    App.EfarMarker.select (efarMarker) =>
      efarMarker.id in @record.efar_ids


class App.EfarMarker extends App.GoogleMapMarker
  @configure App.Efar

  constructor: (efar) ->
    super
    @window = new google.maps.InfoWindow(content: 
      JST["research/views/efars/show"](efar))
    google.maps.event.addListener @marker, 'click', (e) =>
      @window.open(@map, @marker)

  getIcon: ->
    App.MarkerIcon.getIconForId(@record.community_center_id)

    