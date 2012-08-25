class EfarsController < ApplicationController
  def index
    @efars = Efar.all
    
    respond_to do |format|
      format.html
      format.json { render json: @efars }
    end
  end
  
  
end
