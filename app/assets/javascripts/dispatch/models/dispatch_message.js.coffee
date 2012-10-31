class App.DispatchMessage extends Spine.Model
  @configure "DispatchMessage", "efar_id", "dispatch_id", "status"
  
  @extend Spine.Model.Ajax
  @url: "/dispatch_messages"

  constructor: ->
    super
