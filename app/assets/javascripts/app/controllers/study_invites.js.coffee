# class StudyInvite extends Spine.Model
#   @configure "StudyInvite", "efar_id", "accepted"
#   @extend Spine.Model.Ajax
#   @url: "/study_invites"


@module 'App.Controllers.StudyInvites', ->

  class @Index extends Spine.Controller
    elements:
      '[data-type=sendInvite]' : 'sendInviteEl'
    events:
      'click [data-type=sendInvite]' : 'clickSendInvite'

    constructor: ->
      @el = $('#efars-index')
      super()

    clickSendInvite: (e) =>
      e.preventDefault()
      efar_id = $(e.target).data('efar_id')
      statusEl = $(e.target).parent().siblings('.status')
      statusEl.html 'sending'
      $(e.target).hide()
      $.ajax({
        type: "POST"
        url: '/study_invites'
        data: {study_invite: {efar_id: efar_id}}
      }).done(=>
        statusEl.html "sent"
      ).fail(=>
        statusEl.html "failed"
        $(e.target).html "Send again"
        $(e.target).show()
      )



