#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require_tree ./lib
#= require_self
#= require_tree ./research/models
#= require_tree ./research/controllers
#= require_tree ./research/views

class App extends Spine.Controller
  constructor: ->
    super
    @append(new App.EfarsController)

window.App = App