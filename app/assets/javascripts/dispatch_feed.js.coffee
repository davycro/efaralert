#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require spine/route
#= require_self
#= require_tree ./live_feed/views

Spine.Controller.include
  view: (name) ->
    JST["live_feed/views/#{name}"]

class Emergency extends Spine.Model
  @configure "Emergency", "state", "category", "formatted_address", "created_at",
    "num_sent_dispatch_messages", "num_en_route_dispatch_messages",
    "num_on_scene_dispatch_messages", "num_failed_dispatch_messages", "dispatch_messages"
  @extend Spine.Model.Ajax
  @url: "/api/emergencies"

class App extends Spine.Controller
  elements:
    '.dispatch-feed-items' : 'feedItems'

  constructor: ->
    super
    @html @view("dispatch-feed")
    Emergency.bind 'refresh', @change
    Emergency.fetch()

  change: =>
    emergencies = Emergency.all()
    @addOne(em) for em in emergencies

  addOne: (emergency) ->
    @feedItems.append @view('feed-item')(emergency)

window.App = App
