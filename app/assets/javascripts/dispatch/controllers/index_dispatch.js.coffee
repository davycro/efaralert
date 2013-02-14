
class App.IndexDispatch extends Spine.Controller

  constructor:->
    @el = $('#dispatches-index')
    super()
    App.Dispatch.bind 'refresh', @change
    @doPoll()

  change: =>
    records = App.Dispatch.all()
    sortBy = (key, a, b, r) ->
      r = if r then 1 else -1
      return -1*r if a[key] > b[key]
      return +1*r if a[key] < b[key]
      return 0
    
    records.sort (a,b) ->
      sortBy('id', a, b, true)

    @html(@view("dispatches")(records: records))
    jQuery(".timeago").timeago();
    $('.timeago').show()

  doPoll: =>
    App.Dispatch.fetchForPoll()
    setTimeout(@doPoll, 5*1000)