class Research::AccountsController < ApplicationController
  before_filter :require_researcher_login
  layout 'research'

  def show
    @researcher = @current_researcher
  end

  def edit
    @researcher = @current_researcher
  end

  def update
    @researcher = @current_researcher
    if @researcher.update_attributes(params[:researcher])
      redirect_to research_account_path, :notice => "Account updated"
    else
      render :action => "edit"
    end
  end
end
