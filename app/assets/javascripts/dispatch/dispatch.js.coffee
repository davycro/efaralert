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