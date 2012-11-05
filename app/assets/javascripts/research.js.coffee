#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require spine/manager
#= require spine/route
#= require_tree ./lib
#= require_self
#= require_tree ./research/models
#= require_tree ./research/controllers
#= require_tree ./research/views
#= require_tree ./research/lib

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

    Spine.Route.setup()
    @navigate('/emergencies')

window.App = App