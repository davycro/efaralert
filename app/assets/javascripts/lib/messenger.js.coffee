@module 'App', ->
  class @Messenger
    @className: '.messenger'

    @post: (msg) ->
      @setEl()
      @html msg
      @el.show()

    @flash: (msg) ->
      @post(msg)
      @el.delay(2000).fadeOut(1000)

    @error: (msg) ->
      @setEl()
      @el.addClass 'messenger-error'
      @html msg
      @el.show()

    @flashError: (msg) ->
      @error msg
      @el.delay(2000).fadeOut(1000)

    @html: (content) ->
      $('.content', @el).html content

    @setEl: ->
      unless @el
        @el = $(@className)
        @el.bind 'click', =>
          @el.hide()
      @el.removeClass 'messenger-error'

      
