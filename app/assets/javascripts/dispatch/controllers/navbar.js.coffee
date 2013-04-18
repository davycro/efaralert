Efar        = Dispatch.Efar
TextMessage = Dispatch.TextMessage
Config      = Dispatch.Config

class HeadEfarsMenu extends Spine.Controller
  tag: 'ul'

  constructor: ->
    @el = $('[data-type=headEfarsMenu]')
    super()
    @efars = []

    Efar.one 'refresh', =>
      @render()

    Efar.bind 'update', (record) =>
      if record.is_head_efar
        @render()

  render: ->
    @efars = Efar.findAllByAttribute "is_head_efar", true
    if @efars.length>0
      @html @view('headEfarsMenu')({records: @efars})
      @el.show()
    else
      @el.hide()


class NewMessagesMenu extends Spine.Controller
  tag: 'ul'

  constructor: ->
    @el = $('[data-type=newMessagesMenu]')
    super()
    @efars = []

    TextMessage.one 'refresh', =>
      @render()

    Efar.bind 'update', (record) =>
      if record.getUnreadMessages().length > 0
        @render()
      if (efar for efar in @efars when efar.id==record.id).length > 0
        @render()

  render: ->
    @efars = Efar.allWithUnreadMessages()
    if @efars.length>0
      @html @view('newMessagesMenu')({records: @efars, numUnreadMessages: TextMessage.allUnread().length})
      @el.show()
    else
      @el.hide()


class ActiveEfarsMenu extends Spine.Controller
  tag: 'ul'

  constructor: ->
    @el = $('[data-type=activeEfarsMenu]')
    super()
    @efars = []

    TextMessage.one 'refresh', =>
      @render()

    Efar.bind 'update', (record) =>
      if record.getMessages().length > 0
        @render()

  render: ->
    @efars = Efar.allActive()
    if @efars.length>0
      @html @view('activeEfarsMenu')({records: @efars})
      @el.show()
    else
      @el.hide()


class Dispatch.Navbar extends Spine.Controller
  constructor: ->
    super()
    @activeEfarsMenu = new ActiveEfarsMenu()
    @newMessagesMenu = new NewMessagesMenu()
    @headEfarsMenu   = new HeadEfarsMenu()


