class App.Emergency extends Spine.Model
  @configure "Emergency", "lat", "lng", "formatted_address", "efar_ids"
  @extend Spine.Model.Ajax
  @url: "/api/emergencies"

  efars: ->
    App.Efar.select (efar)=>
      efar.id in @efar_ids

