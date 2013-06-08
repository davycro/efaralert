class AdminsController < InheritedResources::Base
  layout 'admin'
  before_filter :require_admin_login


  def update
    update! { admins_url }
  end

  def create
    create! { admins_url }
  end

  def destroy
    @admin = Admin.find(params[:id])
    if @admin==@current_admin
      redirect_to admins_path, :notice => "You cannot delete your own account"
    else
      destroy!
    end
  end


end
