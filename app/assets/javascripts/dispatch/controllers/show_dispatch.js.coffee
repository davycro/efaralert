class DispatchMessagesTable extends Spine.Controller

  constructor:->
    @el = $('[data-type=dispatch-messages-table]')
    super()
    @dispatch_id = @el.data('dispatch-id')
    App.DispatchMessage.bind 'refresh', @change
    @doPoll()

  change: =>
    records = App.DispatchMessage.all()
    @html(JST["dispatch/views/dispatch_messages"](records: records))
    jQuery(".timeago").timeago();
    $('.timeago').show()

  doPoll: =>
    App.DispatchMessage.fetchForDispatch(@dispatch_id)
    setTimeout @doPoll, 6*1000


class App.ShowDispatch extends Spine.Controller

  constructor:->
    super()
    @table = new DispatchMessagesTable
