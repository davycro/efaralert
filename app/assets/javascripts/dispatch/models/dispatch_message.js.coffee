class App.DispatchMessage extends Spine.Model
  @configure "DispatchMessage", "efar_id", "dispatch_id", "state", "efar",
    "updated_at", "efar_location", "efars_origin_location"
  
  @extend Spine.Model.Ajax
  @url: "/api/dispatch_messages"

  constructor: ->
    super

  @fetchForDispatch: (dispatch_id) ->
    @fetch({data: {'dispatch_id': dispatch_id}, processData: true})