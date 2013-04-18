#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require spine/route
#= require spine/manager
#= require jquery.timeago
#= require_self
#= require_tree ./lib
#= require_tree ./dispatch/models
#= require_tree ./dispatch/controllers
#= require_tree ./dispatch/views

#
# Configuration Global

class Config extends Spine.Module

#
# App Global

class App extends Spine.Controller

  constructor: ->
    @el = $('#dispatchApp')
    super()
    # load configuration data
    Config.suburb     = @el.data('suburb')
    Config.dispatcher = @el.data('dispatcher')
    #
    # load layout controllers
    @mapContainer = new Dispatch.MapContainer()
    @append @mapContainer
    @mapContainer.render()
    #
    # load map layers
    @efars = new Dispatch.Efars()
    #
    # misc controllers
    @navbar = new Dispatch.Navbar()
    #
    # boot the router
    Dispatch.Efar.one 'refresh', =>
      Spine.Route.setup()

#
# Helpers

Spine.Controller.include
  view: (name) ->
    JST["dispatch/views/#{name}"]

#
# Setup Globals
Dispatch = @Dispatch = {}
Dispatch.App = App
Dispatch.Config = Config

window.Dispatch = Dispatch

