$ = jQuery.sub()

class App.Topbar extends Spine.Controller
  className: 'topbar'

  events:
    'click a': 'click'

  elements:
    '.nav li': 'li'

  constructor: ->
    super
    @html @view('map_nav')()

  click: (e) =>
    @navigate("/#{$(e.target).data('type')}")

  activate: (type) ->
    @li.removeClass 'active'
    $("a[data-type=#{type}]").parent().addClass 'active'


class Efars extends Spine.Controller

  constructor:->
    super

  activate:->
    super
    m.show() for m in App.EfarMarker.all()
    @

  deactivate:->
    super
    m.hide() for m in App.EfarMarker.all()
    @


class Emergencies extends Spine.Controller

  elements:
    '.nav' : 'nav'

  events:
    'click a' : 'click'

  constructor:->
    super
    @html @view('emergencies/legend')
    App.Emergency.bind 'refresh', (emergencies) =>
      @addEmergency(em) for em in emergencies

  addEmergency:(em) ->
    # update the legend
    @nav.append @view('emergencies/legend_key')(em)

  click: (e) =>
    el     = $(e.target)
    id     = el.data('id')
    marker = App.EmergencyMarker.find(id)
    marker.toggleVisible({pan: true})
    el.parent().toggleClass('active')

  activate: ->
    super
    console.log('activate')
    @

  deactivate: ->
    super
    m.hide() for m in App.EmergencyMarker.all()
    @$('.nav .active').removeClass 'active'
    console.log('deactivate')
    @


class CommunityCenters extends Spine.Controller
  elements:
    '.nav' : 'nav'
  events:
    'click a' : 'click'

  constructor: ->
    super
    @html @view('community_centers/legend')
    App.CommunityCenter.bind 'refresh', (community_centers) =>
      @addCommunityCenter(c) for c in community_centers

  addCommunityCenter: (community_center) ->
    @nav.append @view('community_centers/legend_key')(community_center)

  click: (e) =>
    el     = $(e.target)
    id     = el.data('id')
    marker = App.CommunityCenterMarker.find(id)
    console.log(marker)
    marker.toggleVisible({pan: true})
    el.parent().toggleClass('active')

  activate: ->
    super
    console.log('community_centers activated')
    @

  deactivate: ->
    super
    m.hide() for m in App.CommunityCenterMarker.all()
    @$('.nav .active').removeClass 'active'
    @


class App.Legends extends Spine.Stack
  className: 'legends stack'

  controllers:
    efars             : Efars
    emergencies       : Emergencies
    community_centers : CommunityCenters


