class App.Dispatch extends Spine.Model
  @configure "Dispatch", "readable_location", "emergency_category",
    "created_at", "message_stats"
  
  @extend Spine.Model.Ajax
  @url: "/dispatches"

  # only fetch records that are recent and need to be polled 
  @fetchForPoll: ->
    params = { 'data' : { 'for_poll': true }, processData: true }
    @fetch(params)

  constructor: ->
    super
