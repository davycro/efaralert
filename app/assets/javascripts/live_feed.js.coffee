#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require_tree ./lib
#= require_self
#= require_tree ./live_feed/views
#= require_tree ./live_feed/models

# class EmergencyFeedItem extends Spine.Controller
#   constructor: (emergencyRecord) ->
#     super
#     @emergencyRecord = emergencyRecord 
#     @render()

#   render: ->
#     @html JST["live_feed/views/emergency_feed_item"](@emergencyRecord)


class LiveFeed extends Spine.Controller
  contructor: ->
    super
    console.log('here')
    @append "hello"
    Spine.Route.setup()
  #   Emergency.bind 'refresh', (emergencies) =>
  #     @addAll(emergencies)
  #   Emergency.fetch()
    
  # addAll: (emergencies) ->
  #   @addOne(em) for em in emergencies

  # addOne: (emergency) ->
  #   feedItem = new EmergencyFeedItem(emergency)
  #   @append feedItem





window.LiveFeed = LiveFeed