module ApplicationHelper

  def formatted_dispatch_time(dt)
    dt.strftime("%Hh%M - %d %b %y")
  end

end
