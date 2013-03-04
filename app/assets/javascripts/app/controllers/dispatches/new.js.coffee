
class TownshipSelector extends Spine.Controller

  
  
class AddressSelector extends Spine.Controller


class LocationField extends Spine.Controller
  elements:
    '.modal' : 'modal'

  events:
    'click [data-type=show-modal]' : 'clickShowModal'

  constructor: ->
    @el = $('[data-type=location-field]')
    super
    @append view('location_modal')

  clickShowModal: (e) =>
    e.preventDefault()
    @modal.modal()


@module 'App.Controllers.Dispatches', ->

  class @New extends Spine.Controller

    constructor: (path) ->
      @el = $('#newDispatch')
      super()
      $('select').first().focus()
      @location_field = new LocationField()
      # @address_field = new AddressField()
      # AddressField.bind 'renderAddress', (result) =>
      #   $('input.landmarks').focus()
      #   $('button[type=submit]').removeAttr('disabled')

# Utilities and Shims
view = (name) ->
  JST["app/views/dispatches/#{name}"]
      