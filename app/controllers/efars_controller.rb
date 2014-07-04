class EfarsController < ApplicationController
	before_filter :require_efar_login, :except => [ :new, :create ]
	layout 'efar'

	def new
	end

  def show
  end

  def edit
  end
end
