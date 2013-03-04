
class TownshipSelector extends Spine.Controller



class AddressSelector extends Spine.Controller


class LocationField extends Spine.Controller
  elements:
    '.modal' : 'modal'

  events:
    'click [data-type=show-modal]' : 'clickShowModal'
    'click [data-type=tab-button]' : 'clickTabButton'

  constructor: ->
    @el = $('[data-type=location-field]')
    super
    @append view('location_modal')
    @modal.modal()

  clickShowModal: (e) =>
    e.preventDefault()
    @modal.modal()

  clickTabButton: (e) =>
    e.preventDefault()
    $('.nav-tabs-modal li').removeClass('active')
    target_selector = $(e.currentTarget).attr('href')
    $(e.currentTarget).parent().addClass('active')
    $(target_selector).siblings().removeClass('active')
    $(target_selector).addClass('active')


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
      