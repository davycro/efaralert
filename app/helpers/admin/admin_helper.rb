module Admin::AdminHelper
  def current_community_name
    if @community.present?
      return @community.name 
    else
      return "All Communities"
    end
  end
  def current_efar_category
    case controller.action_name
    when 'active'
      return "Active EFARs"
    when 'bibbed'
      return 'Bibbed EFARs'
    when 'nyc'
      return "Not yet competent EFARs"
    when 'expired'
      return 'Expired EFARs'
    end
    'All EFARs'
  end
  def efars_index_page_title
    str = pluralize(@efars.size, "#{@efars_group_title} EFAR")
    str += " - #{@community.name}" if @community.present?
    str
  end
end