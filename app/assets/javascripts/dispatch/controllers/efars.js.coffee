Efar        = Dispatch.Efar
TextMessage = Dispatch.TextMessage
Config      = Dispatch.Config

class Messages extends Spine.Controller
  @pollLength = 5

  constructor: () ->
    super()

    Efar.one 'refresh', =>
      @doPoll()

    TextMessage.bind 'refresh', ->
      numUnread = TextMessage.allUnread().length
      if numUnread > 0
        titleText = "(#{numUnread}) new messages"
      else
        titleText = "EFAR Dispatch"
      $('title').html titleText

  doPoll: () =>
    TextMessage.fetch()
    setTimeout(@doPoll, @constructor.pollLength*1000)


class Show extends Spine.Controller
  className: 'efar-info-window'
  elements:
    '.text-messages-container' : 'messagesContainer'
    'textarea' : 'textarea'
  events:
    'keypress textarea': 'keypressTextarea'
    'focus textarea': 'focusTextarea'
    'mouseover .text-message-not-viewed-by-dispatcher' : 'mouseoverUnreadMessage'

  constructor: () ->
    super()
    @map     = Config.map
    @window  = new google.maps.InfoWindow()

    @window.setContent(@el[0])

    # scroll messages container to the bottom
    google.maps.event.addListener @window, 'domready', =>
      @refreshElements()
      elem = @messagesContainer
      $(elem).scrollTop(elem[0].scrollHeight)

    google.maps.event.addListener @window, 'closeclick', =>
      @navigate '/efars'

    Efar.bind 'update', (record) =>
      if @record and (@record.id == record.id)
        @change record.id

  active: (params) ->
    @change params.id
    @marker = Markers.find(params.id)
    @window.open(@map, @marker)
    @map.panTo(@marker.getPosition())
    @record.markAllMessagesAsRead()

  change: (id) ->
    @record = Efar.find(id)
    @render()

  render: ->
    @html @view('efarInfoWindow')(@record)

  keypressTextarea: (e) =>
    if e.which==13
      e.preventDefault()
      content = @textarea.val()
      if content
        TextMessage.create({
          content: content
          efar_id: @record.id
          dispatcher_id: Config.dispatcher.id
          sender_name: Config.dispatcher.full_name
          viewed_by_dispatcher: true
        })
        @textarea.val ''

  focusTextarea: (e) =>
    @record.markAllMessagesAsRead()
    true

  mouseoverUnreadMessage: (e) =>
    @record.markAllMessagesAsRead()
    true


class Markers extends Spine.Controller

  @collection = {}

  @find: (id) ->
    @collection[id]

  constructor: () ->
    super()
    @map = Config.map

    Efar.bind 'refresh', (records) =>
      @add record for record in records

    Efar.bind 'update change', (record) =>
      @change record

  add: (record) ->
    if record.is_head_efar
      icon = @headEfarIcon()
      zIndex = 3
    else
      icon = @icon()
      zIndex = 0
    marker = new google.maps.Marker({
      position: record.getPosition()
      icon: icon
      map: @map
      visible: true
      zIndex: zIndex
    })
    google.maps.event.addListener marker, 'click', () =>
      @navigate '/efars', record.id

    @constructor.collection[record.id] = marker 

  change: (record) ->
    marker = @constructor.find(record.id)
    if record.getUnreadMessages().length > 0
      marker.setIcon(@icon('red.png'))
      marker.setZIndex(3)
    else if record.getMessages().length > 0
      marker.setIcon(@icon('green.png'))
      marker.setZIndex(2)
    else if record.is_head_efar
      marker.setIcon(@headEfarIcon())
      marker.setZIndex(2)
    else
      marker.setIcon(@icon())
      marker.setZIndex(1)

  headEfarIcon: ->
    @icon('blue.png')

  icon: (name) ->
    name or= 'gray.png'
    "/assets/fancy_markers/firstaid_#{name}"


class Dispatch.Efars extends Spine.Controller

  constructor: () ->
    super()
    @markers  = new Markers()
    @show     = new Show()
    @messages = new Messages()
    Spine.Route.add('/efars/:id', (params) => @show.active(params))

    Efar.fetch()


