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
    e = App.EfarMarker.find(1445)
    console.log(e)
    @

  deactivate:->
    super
    m.hide() for m in App.EfarMarker.all()
    @


class Emergencies extends Spine.Controller
  className: 'emergencies'

  elements:
    '.nav' : 'nav'

  events:
    'click a' : 'clickSidebarAddress'

  constructor:->
    super
    @html @view('emergencies/index')

    # render sidebar addresses when em models load
    App.Emergency.bind 'refresh', (emergencies) =>
      @addEmergency(em) for em in emergencies

    # connect marker events with the sidebar
    App.EmergencyMarker.bind 'deactivate', (marker) =>
      $("[data-id=#{marker.id}]", @nav).parent().removeClass 'active'  
    App.EmergencyMarker.bind 'activate', (marker) =>
      $("[data-id=#{marker.id}]", @nav).parent().addClass 'active'

  addEmergency:(em) ->
    # update the legend
    @nav.append @view('emergencies/legend_key')(em)

  clickSidebarAddress: (e) =>
    el     = $(e.target)
    id     = el.data('id')
    App.EmergencyMarker.toggleActive(id)

  activate: ->
    super
    m.show() for m in App.EmergencyMarker.all()
    @

  deactivate: ->
    super
    m.hide() for m in App.EmergencyMarker.all()
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
    marker.toggleVisible({pan: true})
    el.parent().toggleClass('active')

  activate: ->
    super
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


