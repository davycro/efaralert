$ = jQuery.sub()

class Show extends Spine.Controller
  className: 'show'

  

class Index extends Spine.Controller
  className: 'index'
  elements:
    ".table-emergencies tbody" : "emergenciesTable"
  events:
    'click [data-type=new]': 'new'
    'click [data-type=show]': 'show'

  constructor: ->
    super
    @render()

    App.Emergency.bind 'refresh change', @change
    App.Emergency.fetch()
    setTimeout @doPoll, 3*1000

  render: =>
    @html @view('emergencies/index')

  change: =>
    console.log('change table')
    emergencies = App.Emergency.all()
    @emergenciesTable.html ''
    @emergenciesTable.prepend(
        @view('emergencies/emergency-row')(em)) for em in emergencies

  new: ->
    @navigate '/dispatches/new'

  doPoll: =>
    console.log('polling')
    App.Emergency.fetchForPoll()
    setTimeout(@doPoll, 5000)

  show: (e) ->
    @redirectTo $(e.currentTarget).data('url')  


class New extends Spine.Controller
  className: 'new'
  events:
    'submit form' : "submit"
  elements:
    '#newModal': 'modal'
    '[name=address]': 'inputAddress'
    '[name=category]': 'inputCategory'
    '.alert': 'alertBox'

  constructor: ->
    super
    @render()
    @setupModal()

  render: ->
    @html @view('emergencies/new')

  activate: ->
    @modal.modal()

  close: ->
    @inputAddress.val ''
    @inputCategory.prop('selectedIndex', 0)
    @alertBox.hide()
    @navigate '/dispatches'

  submit: (e) ->
    e.preventDefault()
    App.Emergency.fromStreetAddress @inputAddress.val(), @inputCategory.val(), {
      success: @success
      failed: @failed }

  success: (em) =>
    # reset modal, flash success message, update table
    @modal.modal 'hide'

  failed: (msg) =>
    @alertBox.show()
    @alertBox.html(msg)
    @inputAddress.focus()  

  setupModal: ->
    @modal.on 'shown', =>
      @inputAddress.focus()
    @modal.on 'hide', =>
      @close()


class App.Dispatches extends Spine.Controller
  className: 'dispatches'

  constructor: ->
    super
    @new = new New
    @index = new Index

    @append @new, @index

    @routes
      "/dispatches/new": ->
        @new.activate()
      "/dispatches": ->

    @navigate '/dispatches'


