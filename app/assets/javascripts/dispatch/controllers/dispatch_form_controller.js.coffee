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

  constructor: ->
    @el = $('#tabPanes')
    super()


class App.NewDispatch extends Spine.Controller
  elements:
    '.nav-tabs li' : 'navTabsLi'
  events:
    'click .nav-tabs a' : 'clickTab'

  constructor: (path) ->
    @el = $('#newDispatch')
    super()
    @tabs_panes = new TabPanes

    @routes
      "/street_address": (params) ->
        @tabs_panes.street_address.active(params)
        $('[data-tab=street_address]').addClass('active')
      "/township": (params) ->
        @tabs_panes.township.active(params)
        $('[data-tab=township]').addClass('active')

    Spine.Route.setup()
    path or= '/street_address'
    @navigate(path)


  clickTab: (e) =>
    @navTabsLi.removeClass('active')
    $(e.currentTarget).parent().addClass('active')
