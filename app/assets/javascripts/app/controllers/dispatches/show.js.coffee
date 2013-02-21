class DispatchMessage extends Spine.Model
  @configure "DispatchMessage", "efar_id", "dispatch_id", "state", "efar",
    "updated_at", "efar_location", "efars_origin_location"
  
  @extend Spine.Model.Ajax
  @url: "/api/dispatch_messages"

  constructor: ->
    super

  @fetchForDispatch: (dispatch_id) ->
    @fetch({data: {'dispatch_id': dispatch_id}, processData: true})


class DispatchMessagesTable extends Spine.Controller

  constructor:->
    @el = $('[data-type=dispatch-messages-table]')
    super()
    @dispatch_id = @el.data('dispatch-id')
    @view = JST["app/views/dispatches/dispatch_messages"] 
    DispatchMessage.bind 'refresh', @change
    @doPoll()

  change: =>
    records = DispatchMessage.all()
    @html(@view(records: records))
    jQuery(".timeago").timeago();
    $('.timeago').show()

  doPoll: =>
    DispatchMessage.fetchForDispatch(@dispatch_id)
    setTimeout @doPoll, 6*1000

@module 'App.Controllers.Dispatches', ->

  class @Show extends Spine.Controller

    constructor:->
      super()
      @table = new DispatchMessagesTable
