class AccountsController < ApplicationController
  before_filter :require_dispatcher_login
  layout 'dispatch'

  def show
    @dispatcher = @current_dispatcher
  end

  def edit
    @dispatcher = @current_dispatcher
  end

  def update
    @dispatcher = @current_dispatcher
    if @dispatcher.update_attributes(params[:dispatcher])
      redirect_to account_path, :notice => "Account updated"
    else
      render :action => "edit"
    end
  end
end
