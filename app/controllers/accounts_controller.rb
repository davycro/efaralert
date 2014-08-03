class AccountsController < ApplicationController

  layout 'main'
  before_filter :require_manager_login

  def show
    @manager = @current_manager
  end

  def edit
    @manager = @current_manager
  end

  def update
    @manager = @current_manager
    @manager.update_attributes params[:manager]
    if @manager.save
      redirect_to account_path, notice: 'changes saved'
    else
      render action: 'edit'
    end
  end
end
