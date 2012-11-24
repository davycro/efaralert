module Research::EmergenciesHelper

  def emergency_state_label_html(emergency)
    # style the label tag based on the emergency state
    # classnames come from twitter bootstrap
    state_classnames = {
      'new' => 'label-info',
      'sending' => 'label-warning',
      'sent' => 'label-success',
      'failed_no_airtime' => 'label-important',
      'no_efars_nearby' => '', # default gray
      'failed_unknown_error' => 'label-important'
    }
    content_tag :span, emergency.state_message, 
      :class => "label #{state_classnames[emergency.state]}"
  end

  def dispatch_message_state_label_html(dispatch_message)
    # same as emergency_state_label_html
    # nil = default gray
    state_classnames = {
      'queued' => '',
      'sending' => 'label-warning',
      'sent' => '',
      'en_route' => 'label-info',
      'on_scene' => 'label-success',
      'failed_unknown' => 'label-important',
      'failed_no_airtime' => 'label-important',
      'failed_invalid_contact_number' => 'label-important'
    }
    content_tag :span, dispatch_message.state_message,
      :class => "label #{state_classnames[dispatch_message.state]}"
  end

  def detailed_datetime(dt)
    dt.in_time_zone("Mountain Time (US & Canada)").strftime("%-I:%M %p - %d %b %y")
  end

end
