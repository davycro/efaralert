#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require spine/spine
#= require spine/ajax
#= require_tree ./lib
#= require_self
#= require_tree ./dispatch/models
#= require_tree ./dispatch/lib

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


window.App = App