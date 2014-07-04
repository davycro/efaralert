class EfarsController < InheritedResources::Base
	before_filter :require_efar_login, :except => [ :new, :create ]
	layout 'efar'


  def create
    @efar = Efar.new params[:efar]
    @efar.community_center = CommunityCenter.first
    create!
  end

end
