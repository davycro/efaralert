#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require_tree ./lib
#= require_self

class Emergency extends Spine.Model
  @configure "Emergency", "lat", "lng", "location_type", "input_address",
    "formatted_address", "created_at", "created_at"
  @extend Spine.Model.Ajax
  @url: "/api/emergencies"


class LiveFeed extends Spine.Controller

  contructor: ->
    super

window.LiveFeed = LiveFeed