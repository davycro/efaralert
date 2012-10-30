class EmergenciesController < ApplicationController

  before_filter :require_dispatcher_login
  layout 'dispatch'

  def new
    @emergency = Emergency.new
  end

  def index
    @emergencies = current_dispatcher.emergencies
  end

  def create
    @emergency = Emergency.new(params[:emergency])
    @emergency.dispatcher = current_dispatcher
    respond_to do |format|
      if @emergency.save
        format.html { redirect_to emergencies_path, notice: 'Efar was successfully created.' }
        format.json { render json: @emergency, status: :created, location: @emergency }
      else
        format.html { render action: "new" }
        format.json { render json: @emergency.errors, status: :unprocessable_entity }
      end
    end
  end
end
