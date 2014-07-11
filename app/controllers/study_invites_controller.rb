class StudyInvitesController < InheritedResources::Base
  before_filter :require_admin_login, :except => [ :show, :accept, :reject ]
  layout 'admin'

  def index
    @efars = Efar.order('id DESC').all
  end

  def pending
    @study_invites = StudyInvite.pending.order('id DESC').all
  end

  def accepted
    @study_invites = StudyInvite.accepted.order('id DESC').all
  end

  def accept
    @study_invite = StudyInvite.find params[:id]
    @study_invite.accepted!
    render :text => "Thank you #{@study_invite.efar.full_name}, you are enrolled in the SMS alert service"
  end

  def reject
    @study_invite = StudyInvite.find params[:id]
    @study_invite.rejected!
    render :text => "#{@study_invite.efar.full_name}, you are no longer in the SMS alert service"
  end

  def create
    @study_invite = StudyInvite.where(params[:study_invite]).first || StudyInvite.new(params[:study_invite])
    if @study_invite.save
      @study_invite.deliver!
    end
    render json: @study_invite
  end

  def show
    @study_invite = StudyInvite.find(params[:id])
    @study_invite.opened!
    render :layout => false
  end
end
