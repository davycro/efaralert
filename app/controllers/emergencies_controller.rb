class EmergenciesController < ApplicationController

  before_filter :require_dispatcher_login
  layout 'dispatch'

  def new
    @emergency = Emergency.new
  end

  def index
    @emergencies = current_dispatcher.emergencies.order('created_at DESC')
    respond_to do |format|
      format.html
      format.json { render json: @emergencies.to_json }
    end
  end

  def show
    @emergency = Emergency.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @emergency.to_json(:methods => [:num_efars_notified]) }
    end
  end

  def create
    @emergency = Emergency.new(params[:emergency])
    @emergency.dispatcher = current_dispatcher
    respond_to do |format|
      if @emergency.save
        @emergency.dispatch_messages.each { |m| m.deliver! }
        format.html { redirect_to emergencies_path, notice: 'Efar was successfully created.' }
        format.json { render json: @emergency.to_json(:methods => [:num_efars_notified]), status: :created, location: @emergency }
      else
        format.html { render action: "new" }
        format.json { render json: @emergency.errors, status: :unprocessable_entity }
      end
    end
  end
end
