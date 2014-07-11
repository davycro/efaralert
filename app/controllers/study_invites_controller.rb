class StudyInvitesController < InheritedResources::Base
  before_filter :require_admin_login
  layout 'admin'

  def index
    @efars = Efar.order('id DESC').all
  end

  def new
  end

  def pending
    @study_invites = StudyInvite.pending.order('id DESC').all
  end

  def accepted
    @study_invites = StudyInvite.accepted.order('id DESC').all
  end

  def create
    @study_invite = StudyInvite.new(params[:study_invite])
    @study_invite.save
    render json: @study_invite
  end
end
