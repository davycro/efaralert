class EfarsController < InheritedResources::Base
	before_filter :require_manager_login
	layout 'main'

end
