class StudyInvite extends Spine.Model
  @configure "StudyInvite", "efar_id", "accepted"
  @extend Spine.Model.Ajax
  @url: "/study_invites"


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
      $.ajax({
        type: "POST"
        url: '/study_invites'
        data: {study_invite: {efar_id: efar_id}}
      }).done(=>
        $(e.target).html "Invite Sent, click to send again"
      ).fail(=>
        $(e.target).html "Failed, click to send again"
      )



