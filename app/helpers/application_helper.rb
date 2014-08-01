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

  def horizontal_select(record, record_attribute, choices, locals={})
    locals[:record] = record
    locals[:record_attribute] = record_attribute
    locals[:label] ||= record_attribute.to_s.titleize
    locals[:choices] = choices
    render partial: "shared/horizontal_select", locals: locals 
  end

  def horizontal_date_select(record, record_attribute, locals={})
    locals[:record] = record
    locals[:record_attribute] = record_attribute
    locals[:label] ||= record_attribute.to_s.titleize
    locals[:order] ||= [:day, :month, :year]
    render partial: "shared/horizontal_date_select", locals: locals 
  end

  def horizontal_check_box(record, record_attribute, locals={})
    locals[:record] = record
    locals[:record_attribute] = record_attribute
    locals[:label] ||= record_attribute.to_s.titleize
    render partial: 'shared/horizontal_check_box', locals: locals
  end

  def horizontal_form_actions(locals={})
    render partial: 'shared/horizontal_form_actions', locals: locals
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
