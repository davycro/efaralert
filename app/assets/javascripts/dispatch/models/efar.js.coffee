class TextMessage extends Spine.Model
  @configure "TextMessage", "efar_id", "content",
    "dispatcher_id", "viewed_by_dispatcher", 
    "sender_name", "readable_time"
  @extend Spine.Model.Ajax
  @url: "/text_messages"

  @fetch: (params) ->
    params or= {data: $.param({index: @last()?.id})}
    super(params)

  @bind 'refresh', (records) ->
    record.updateEfar() for record in records  

  @bind 'change', (record) ->
    record.updateEfar()

  @allUnread: () ->
    @findAllByAttribute "viewed_by_dispatcher", false

  updateEfar: () ->
    efar = Efar.exists(@efar_id)
    if efar
      efar.trigger('update')

  markAsRead: () ->
    unless @viewed_by_dispatcher
      @viewed_by_dispatcher = true
      @save()


class Efar extends Spine.Model
  @configure "Efar", "formatted_address", "lat", "lng", "full_name",
    "given_address", "is_head_efar", "is_active"
  @extend Spine.Model.Ajax
  @url: "/efars"

  constructor: (atts) ->
    super(atts)

  getPosition: () ->
    new google.maps.LatLng(@lat, @lng)

  getMessages: () ->
    TextMessage.findAllByAttribute "efar_id", @id

  getUnreadMessages: () ->
    result = (message for message in @getMessages() when !message.viewed_by_dispatcher)
    return result

  getReadMessages: () ->
    result = (message for message in @getMessages() when message.viewed_by_dispatcher)
    return result

  markAllMessagesAsRead: () ->
    message.markAsRead() for message in @getUnreadMessages()

  # has messages from the last 6 hours
  @allActive: () ->
    results = {}
    results[m.efar_id] or= @find(m.efar_id) for m in TextMessage.all()
    results[record.id] or= record for record in Efar.findAllByAttribute("is_active", true)
    values = []
    for key,value of results
      values.push value
    values

  @allWithUnreadMessages: () ->
    result = (record for record in @allActive() when record.getUnreadMessages().length>0)
    return result 



Dispatch.TextMessage = TextMessage
Dispatch.Efar = Efar