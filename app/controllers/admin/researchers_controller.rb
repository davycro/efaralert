class Admin::ResearchersController < ApplicationController
  layout 'efar_admin'

  before_filter :require_admin_login

  def index
    @researchers = Researcher.all
  end

  def edit
    @researcher = Researcher.find(params[:id])
  end

  def new
    @researcher = Researcher.new
  end

  def show
    @researcher = Researcher.find(params[:id])
  end

  def create
    @researcher = Researcher.new(params[:researcher])
    if @researcher.save
      redirect_to admin_researchers_path, :notice => "New researcher created"
    else
      render :action => 'new'
    end
  end

  def update
    @researcher = Researcher.find(params[:id])
    if @researcher.update_attributes(params[:researcher])
      redirect_to admin_researchers_path, :notice => "Changes saved"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @researcher = Researcher.find(params[:id])
    @researcher.destroy
    redirect_to admin_researchers_path, :notice => "Researcher destroyed"
  end
end
