class App.CommCenter extends Spine.Model
  @configure "CommunityCenter", "lat", "lng", "name", "suburb"
  @extend Spine.Model.Ajax
  @url: "/research/community_centers"

  constructor: ->
    super
    @efars = App.Efar.selectForCommCenter(@)

  getIcon: ->
    App.MarkerIcon.getIconForId(@id)
    