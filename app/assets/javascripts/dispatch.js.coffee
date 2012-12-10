#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require spine/route
#= require_tree ./lib
#= require_self
#= require_tree ./dispatch/models
#= require_tree ./dispatch/controllers
#= require_tree ./dispatch/views
#= require_tree ./dispatch/lib

class App extends Spine.Controller
  constructor: ->
    super
    @append(new App.Dispatches)
    Spine.Route.setup()

window.App = App