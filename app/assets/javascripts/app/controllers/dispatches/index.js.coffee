class Dispatch extends Spine.Model
  @configure "Dispatch", "readable_location", "emergency_category",
    "created_at", "message_stats", "readable_timestamps"
  
  @extend Spine.Model.Ajax
  @url: "/dispatches"

  # only fetch records that are recent and need to be polled 
  @fetchForPoll: ->
    params = { 'data' : { 'for_poll': true }, processData: true }
    @fetch(params)

  constructor: ->
    super


@module 'App.Controllers.Dispatches', ->

  class @Index extends Spine.Controller

    constructor:->
      @el = $('#dispatches-index')
      super()
      @view = JST["app/views/dispatches/index"]
      Dispatch.bind 'refresh', @change
      @doPoll()

    change: =>
      records = Dispatch.all()
      sortBy = (key, a, b, r) ->
        r = if r then 1 else -1
        return -1*r if a[key] > b[key]
        return +1*r if a[key] < b[key]
        return 0
      
      records.sort (a,b) ->
        sortBy('id', a, b, true)

      @html(@view(records: records))
      jQuery(".timeago").timeago();
      $('.timeago').show()

    doPoll: =>
      Dispatch.fetchForPoll()
      setTimeout(@doPoll, 5*1000)