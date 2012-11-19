#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require spine/manager
#= require spine/route
#= require_tree ./lib
#= require_self
#= require_tree ./mapper/models
#= require_tree ./mapper/controllers
#= require_tree ./mapper/views
#= require_tree ./mapper/lib

class App extends Spine.Controller
  constructor: ->
    super
    @append "<div id='map'></div>"
    App.GoogleMap.render($('#map'))

    @topbar  = new App.Topbar
    @legends = new App.Legends

    @routes
      '/emergencies': (params) ->
        @topbar.activate('emergencies')
        @legends.emergencies.active()
        
      '/efars': (params) ->
        @topbar.activate('efars')
        @legends.efars.active()

      '/community_centers': (params) ->
        @topbar.activate('community_centers')
        @legends.community_centers.active()

    @append @topbar, @legends

    App.Emergency.fetch()
    App.Efar.fetch()
    App.CommunityCenter.fetch()
    App.DispatchMessage.fetch()

    Spine.Route.setup()
    @navigate('/emergencies')

window.App = App