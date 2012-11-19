class App.CommunityCenter extends Spine.Model
  @configure "CommunityCenter", "lat", "lng", "name", "suburb"
  @extend Spine.Model.Ajax
  @url: "/api/community_centers"

  constructor: ->
    super
    # @efars = App.Efar.selectForCommCenter(@)

  getIcon: ->
    App.MarkerIcon.getIconForId(@id)
    