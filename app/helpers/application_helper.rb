module ApplicationHelper

  def formatted_dispatch_time(dt)
    dt.strftime("%Hh%M - %d %b %y")
  end

  def horizontal_text_field(record, record_attribute, locals={})

    locals[:record] = record
    locals[:record_attribute] = record_attribute
    locals[:label] ||= record_attribute.to_s.titleize
    locals[:placeholder] ||= ""
    locals[:help_text]  ||= ""

    render :partial => "shared/horizontal_text_field", 
      :locals => locals
  end

  def horizontal_password_field(record, locals={})
    locals[:record] = record

    render :partial => "shared/horizontal_password_field",
      :locals => locals
  end

  def community_center_selector_field(record, locals={})
    locals[:record] = record
    render partial: "shared/community_center_selector_field", locals: locals
  end

  def display_alert_location_and_landmark(alert)
    str = ""
    str += alert.given_location if alert.given_location.present?
    if alert.landmarks.present?
      str += " (#{alert.landmarks})"
    end
    str
  end

end
