class Efar extends Spine.Model
  @configure "Efar", "formatted_address", "lat", "lng", "full_name", 
    "contact_number", "readable_contact_number"
  @extend Spine.Model.Ajax
  @url: "/efars"

  @labelMap = { }
  @labels = [ ]

  @one 'refresh', ->
    Efar.each (efar) ->
      label = "#{efar.full_name} '#{efar.readable_contact_number}'"
      Efar.labelMap[label] = efar.id
      Efar.labels.push label
    @trigger 'labelsready'



@module 'App.Controllers.Efars', ->

  class @Message extends Spine.Controller
    elements:
      'input[data-type=recipients]' : 'recipientsInput'
      'textarea' : 'textarea'
      '.alert[data-type=sending]' : 'sendingAlert'
      '.alert[data-type=failed]' : 'failedAlert'
      '.control-group[data-type=toSend]' : 'toSendControlGroup'
      '.control-group[data-type=sent]' : 'sentControlGroup'
      '.control-group[data-type=error]' : 'errorControlGroup'

    events:
      'submit form' : 'submitForm'
      'click .remove' : 'clickRemove'

    constructor: ->
      @el = $('#message')
      super()

      Efar.bind 'labelsready', =>
        @enableRecipientsInput()
      Efar.fetch()

    enableRecipientsInput: ->
      @recipientsInput.removeAttr('disabled')
      @recipientsInput.attr('value', '')
      @recipientsInput.typeahead({
        source: Efar.labels
        updater: @updateRecipientInput
        })

    updateRecipientInput: (item) =>
      efar = Efar.find Efar.labelMap[item]
      efar.tokenType = 'toSend'
      $('.tokens', @toSendControlGroup).append view('messageToken')(efar)
      ''

    allMessagesSent: () ->
      @toSendControlGroup.hide()

    sendNextMessage: () ->
      el = $('.token[data-type=toSend]').first()
      if el.length < 1
        @allMessagesSent()
        return true
      efar = Efar.find $(el).data('id')
      $.ajax({
        type: "POST"
        url: "/efars/#{efar.id}/text_message"
        data: {message: @textarea.attr('value')}
      }).done(=>
        efar.tokenType = 'sent'
        $(el).remove()
        @sentControlGroup.show()
        $('.tokens', @sentControlGroup).append view('messageToken')(efar)
        @sendNextMessage()
      ).fail(=>
        efar.tokenType = 'error'
        $(el).remove()
        @errorControlGroup.show()
        $('.tokens', @errorControlGroup).append view('messageToken')(efar)
        @sendNextMessage()
      )
    
    validateRecipients: () ->
      # stop if there are no recipients
      if $('.token[data-type=toSend]').length < 1
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

    submitForm: (e) =>
      e.preventDefault()
      return true unless @validateMessage() and @validateRecipients()

      $('button[type=submit]').attr('disabled', 'true')
      $('.form-actions').hide()
      $('.sent-message').append "<blockquote>#{@textarea.attr('value')}</blockquote>"
      @textarea.hide()
      @recipientsInput.hide()
      $('.token .remove').remove()
      $('.token').addClass('token-disabled')
      $('.control-label', @toSendControlGroup).html 'Sending'
      #
      @sendNextMessage()

    clickRemove: (e) =>
      $(e.srcElement).parent().remove()

view = (name) ->
  JST["app/views/efars/#{name}"]

