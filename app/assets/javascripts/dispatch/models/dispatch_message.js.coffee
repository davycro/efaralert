class App.DispatchMessage extends Spine.Model
  @configure "DispatchMessage", "efar_id", "dispatch_id", "state", "efar"
  
  @extend Spine.Model.Ajax
  @url: "/api/dispatch_messages"

  constructor: ->
    super

  @fetchForEmergency: (emergency_id) ->
    @fetch({data: {'emergency_id': emergency_id}, processData: true})