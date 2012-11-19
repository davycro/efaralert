class App.DispatchMessage extends Spine.Model
  @configure "DispatchMessage", "lat", "lng", "efar_id", "emergency_id", 
    "status"
  @extend Spine.Model.Ajax
  @url: "/api/dispatch_messages"

  efar: ->
    App.Efar.find(@efar_id)

