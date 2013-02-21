AddressField = GeocoderUi.AddressField

@module 'App.Controllers.Dispatches', ->

  class @New extends Spine.Controller

    constructor: (path) ->
      @el = $('#newDispatch')
      super()
      $('select').first().focus()
      @address_field = new AddressField()
      AddressField.bind 'renderAddress', (result) =>
        $('input.landmarks').focus()
        $('button[type=submit]').removeAttr('disabled')
      