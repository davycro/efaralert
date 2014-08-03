
@module 'App.Controllers', ->

  class @GroupMessageModal extends Spine.Controller
    elements:
      'form' : 'form'
      'button' : 'button'
      'textarea' : 'textarea'
      '[data-type=sent-group]': 'sentGroup'
      '[data-type=error-group]':'errorGroup'
      '[data-type=sending]' : 'sendingBox'
      '[data-type=cancel]' : 'cancelLink'
    events:
      'click button' : 'clickButton'
      'submit form' : 'submitForm'

    constructor: ->
      @el = $('#groupMessageModal')
      super()
      @loadEfars()

    done: () ->
      @sendingBox.html "Done. Message sent."
      @button.hide()
      @cancelLink.html "All messages sent, click to close window"
      @cancelLink.show()

    sendNextMessage: () ->
      if @efars.length < 1
        @done()
        return true
      efar = @efars.shift()
      $.ajax({
        type: "POST"
        url: "/efars/#{efar.id}/text_message"
        data: {message: @textarea.attr('value')}
      }).done(=>
        efar.tokenType = 'sent'
        @sentGroup.show()
        $('.tokens', @sentGroup).append "#{efar.full_name}; "
        @sendNextMessage()
      ).fail(=>
        efar.tokenType = 'error'
        @errorGroup.show()
        $('.tokens', @errorGroup).append "#{efar.full_name}; "
        @sendNextMessage()
      )

    loadEfars: ->
      @efars = $(@form).data('efars')

    validateRecipients: () ->
      # stop if there are no recipients
      if @efars.length < 1
        alert "Must be at least one recipient"
        return false
      else
        return true

    validateMessage: () ->
      if @textarea.attr('value').length < 10
        alert "Message must be longer than 10 characters"
        return false
      else
        return true

    clickButton: (e) =>
      e.preventDefault()
      $(@form).submit()

    submitForm: (e) =>
      e.preventDefault()
      return true unless @validateMessage() and @validateRecipients()
      return true unless confirm "#{@efars.length} will be text messaged. Are you sure that you want to send this message?"
      @button.attr('disabled', 'true')
      @button.html "Sending message..."
      @cancelLink.hide()
      $('.sent-message').append "<blockquote>#{@textarea.attr('value')}</blockquote>"
      @textarea.hide()
      @sendingBox.show()
      @sendNextMessage()




