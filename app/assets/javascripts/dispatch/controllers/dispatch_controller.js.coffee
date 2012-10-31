$ = jQuery.sub()

class App.DispatchController extends Spine.Controller
  elements:
    "#myModal" : "myModal"
    "#input-address" : "inputAddress"
    ".table-emergencies tbody" : "emergenciesTable"
    "#myModal .alert" : "dispatchAlertBox"

  events:
    "submit form" : "sendDispatch"
    "click .btn-new-dispatch" : "newDispatch"

  constructor: ->
    super
    @html JST["dispatch/views/emergencies/index"]

    App.Emergency.bind 'refresh', (emergencies) =>
      @emergenciesTable.html ''
      @emergenciesTable.prepend(
        JST["dispatch/views/emergencies/emergency-row"](em)) for em in emergencies
    
    App.Emergency.fetch()
    
    @setupModal()

  setupModal: ->
    @myModal.on 'shown', =>
      @inputAddress.focus()
    @myModal.on 'hide', =>
      @inputAddress.val ''
      @dispatchAlertBox.hide()

  sendDispatch: (e) ->
    # disable form, propagate dispatch
    e.preventDefault()
    App.Emergency.fromStreetAddress @inputAddress.val(), {
      success: @dispatchSuccess
      failed: @dispatchFailed }

  dispatchSuccess: (em) =>
    # reset modal, flash success message, update table
    App.Emergency.fetch()
    @myModal.modal 'hide'

  dispatchFailed: (msg) =>
    @dispatchAlertBox.show()
    @dispatchAlertBox.html(msg)
    @inputAddress.focus()

  newDispatch: (e) ->
    @myModal.modal() 

