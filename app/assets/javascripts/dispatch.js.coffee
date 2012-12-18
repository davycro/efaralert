#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require_tree ./lib
#= require_self
#= require_tree ./dispatch/models
#= require_tree ./dispatch/lib

class EmergencyIndexController
  constructor:->
    App.Emergency.bind 'refresh change', @change
    # App.Emergency.fetch()
    setTimeout @doPoll, 3*1000

  change: =>
    emergencies = App.Emergency.all()
    @updateStats(em) for em in emergencies

  updateStats: (emergency) ->
    elem = $("[data-emergency-id=#{emergency.id}]")
    $('[data-type=emergency-sent-messages-count]', elem).html(emergency.num_sent_dispatch_messages)
    $('[data-type=emergency-en-route-messages-count]', elem).html(emergency.num_en_route_dispatch_messages)
    $('[data-type=emergency-on-scene-messages-count]', elem).html(emergency.num_on_scene_dispatch_messages)
    $('[data-type=emergency-failed-messages-count]', elem).html(emergency.num_failed_dispatch_messages)

  doPoll: =>
    App.Emergency.fetchForPoll()
    setTimeout(@doPoll, 5*1000)


class NewDispatchModalController
  constructor: ->
    @setElements()
    @setEvents()
    @setupModal()

  setElements: ->
    @modal = $('#newDispatchModal')
    @form = $('form', @modal)
    @inputAddress = $('[name=address]', @modal)
    @inputCategory = $('[name=category]', @modal)
    @alertBox = $('.alert', @modal)

  setEvents: ->
    $('[data-type=new-dispatch]').bind 'click', =>
      @modal.modal()

    @form.bind 'submit', (e) =>
      @submit(e)

  submit: (e) ->
    e.preventDefault()
    App.Emergency.fromStreetAddress @inputAddress.val(), @inputCategory.val(), {
      success: @success
      failed: @failed }

  success: (em) =>
    window.location = '/emergencies'

  failed: (msg) =>
    @alertBox.show()
    @alertBox.html(msg)
    @inputAddress.focus()

  setupModal: ->
    @modal.on 'shown', =>
      @inputAddress.focus()
    @modal.on 'hide', =>
      @closeModal()

  closeModal: ->
    @inputAddress.val ''
    @inputCategory.prop('selectedIndex', 0)
    @alertBox.hide()

class App
  constructor: ->
    @modalController = new NewDispatchModalController
    @emergencyIndexController = new EmergencyIndexController


window.App = App