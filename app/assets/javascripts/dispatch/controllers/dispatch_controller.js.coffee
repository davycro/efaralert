$ = jQuery.sub()

class App.DispatchController extends Spine.Controller
  elements:
    ".form-dispatch" : "dispatchForm"

  events:
    "click .btn-send" : "sendDispatch"

  constructor: ->
    super
    @html JST["dispatch/views/emergencies/new"]

  sendDispatch: (e) ->
    App.Emergency.fromStreetAddress $('input[name=input_location]').val()
