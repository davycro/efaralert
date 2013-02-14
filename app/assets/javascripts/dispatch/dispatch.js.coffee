#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require spine/route
#= require spine/manager
#= require jquery.timeago
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./lib
#= require_tree ./views

class ShowController
  constructor:->
    @dispatchMessages = $('[data-type=dispatch-messages]')
    @notice = $('.notice', @dispatchMessages)
    @emergencyId = $(@dispatchMessages).data('emergency-id')
    App.DispatchMessage.bind 'refresh', @change
    @doPoll()

  change: =>
    messages = App.DispatchMessage.all()
    if messages.length == 0
      @notice.html "No nearby efars"
    else
      @dispatchMessages.html ''
      @dispatchMessages.append(JST["dispatch/views/dispatch-message"](m)) for m in messages
    jQuery(".timeago").timeago();

  doPoll: =>
    App.DispatchMessage.fetchForEmergency(@emergencyId)
    setTimeout @doPoll, 6*1000


class IndexController
  constructor:->
    App.Emergency.bind 'refresh change', @change
    @doPoll()

  change: =>
    emergencies = App.Emergency.all()
    @updateStats(em) for em in emergencies

  updateStats: (emergency) ->
    elem = $("[data-emergency-id=#{emergency.id}]")
    @updateStat $('[data-type=emergency-sent-messages-count]', elem), 
      emergency.num_sent_dispatch_messages 
    @updateStat $('[data-type=emergency-en-route-messages-count]', elem), 
      emergency.num_en_route_dispatch_messages 
    @updateStat $('[data-type=emergency-on-scene-messages-count]', elem), 
      emergency.num_on_scene_dispatch_messages
    @updateStat $('[data-type=emergency-declined-messages-count]', elem), 
      emergency.num_declined_dispatch_messages 
    @updateStat $('[data-type=emergency-failed-messages-count]', elem), 
      emergency.num_failed_dispatch_messages 

  updateStat: (elem, number) ->
    if number==0
      $(elem).hide()
    if number>0
      $('span', elem).html(number)  
      $(elem).show()

  doPoll: =>
    App.Emergency.fetchForPoll()
    setTimeout(@doPoll, 5*1000)





class App
  constructor: (path) ->
    # if path=='emergencies/index'
    #   @emergencyIndexController = new IndexController
    # if path=='emergencies/show'
    #   @showController = new ShowController
    # if path=='emergencies/new'
    #   @mapController = new MapController
    # if path=='dispatches/new' or path=='dispatches/create'
    #   @newDispatch = new App.NewDispatch

    

jQuery(".timeago").timeago();
window.App = App