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



class App.Legends extends Spine.Stack
  className: 'legends stack'

  controllers:
    efars: Efars
    emergencies: Emergencies    


