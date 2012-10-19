class EfarsController < ApplicationController
  # GET /efars
  # GET /efars.json
  def index
    @efars = Efar.limit(100).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @efars }
    end
  end

  # GET /efars/1
  # GET /efars/1.json
  def show
    @efar = Efar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @efar }
    end
  end

  # GET /efars/new
  # GET /efars/new.json
  def new
    @efar = Efar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @efar }
    end
  end

  # GET /efars/1/edit
  def edit
    @efar = Efar.find(params[:id])
  end

  # POST /efars
  # POST /efars.json
  def create
    @efar = Efar.new(params[:efar])

    respond_to do |format|
      if @efar.save
        format.html { redirect_to @efar, notice: 'Efar was successfully created.' }
        format.json { render json: @efar, status: :created, location: @efar }
      else
        format.html { render action: "new" }
        format.json { render json: @efar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /efars/1
  # PUT /efars/1.json
  def update
    @efar = Efar.find(params[:id])

    respond_to do |format|
      if @efar.update_attributes(params[:efar])
        format.html { redirect_to @efar, notice: 'Efar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @efar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /efars/1
  # DELETE /efars/1.json
  def destroy
    @efar = Efar.find(params[:id])
    @efar.destroy

    respond_to do |format|
      format.html { redirect_to efars_url }
      format.json { head :no_content }
    end
  end
  
end
