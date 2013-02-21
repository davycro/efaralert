@module 'App.Controllers.Admin.Efars', ->
  class @Form extends Spine.Controller

    constructor: ->
      @el = $('.efar-form-editor')
      super()
      @address_field = new GeocoderUi.AddressField()  


