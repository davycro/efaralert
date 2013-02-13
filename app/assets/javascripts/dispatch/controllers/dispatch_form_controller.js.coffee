class StreetAddressTab extends Spine.Controller

  constructor: ->
    @el = $('#streetAddressFormTab')
    super()
    @geocoded_address_field = new App.GeocodedAddressField
    App.GeocodedAddressField.bind 'renderAddress', (result) =>
      $('input.landmarks').focus()
      $('button[type=submit]').removeAttr('disabled')

  active: (params) ->
    super()
    $('select').first().focus()


class TownshipTab extends Spine.Controller

  constructor: ->
    @el = $('#townshipFormTab')
    super()

  active: (params) ->
    super()
    $('select', @el).first().focus()


class TabPanes extends Spine.Stack
  controllers:
    township: TownshipTab
    street_address: StreetAddressTab

  routes:
    '/street_address' : 'street_address'
    '/township' : 'township'

  constructor: ->
    @el = $('#tabPanes')
    super()


class App.NewDispatch extends Spine.Controller
  elements:
    '.nav-tabs li' : 'navTabsLi'
  events:
    'click .nav-tabs a' : 'clickTab'

  constructor: ->
    @el = $('#newDispatch')
    super()
    @tabs_panes = new TabPanes

    Spine.Route.setup()
    @navigate('/street_address')

  clickTab: (e) =>
    @navTabsLi.removeClass('active')
    $(e.currentTarget).parent().addClass('active')
