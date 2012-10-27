#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree .

class App extends Spine.Controller
  constructor: ->
    super
    @append(new App.EfarsController)

window.App = App