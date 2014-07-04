class EfarsController < InheritedResources::Base
	before_filter :require_efar_login, :except => [ :new, :create ]
	layout 'efar'

end
