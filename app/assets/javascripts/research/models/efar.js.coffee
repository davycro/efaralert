class App.Efar extends Spine.Model
  @configure "Efar", "street", "suburb", "postal_code", "city", 
    "country", "lat", "lng", "first_names", "surname", 
    "location_type", "training_score", "community_center_id"
  @extend Spine.Model.Ajax
  @url: "/api/efars"
  
  @selectForCommunityCenter: (center) ->
    @select (efar) ->
      efar.community_center_id == center.id

  constructor: ->
    super
    


