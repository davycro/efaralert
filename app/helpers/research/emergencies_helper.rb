module Research::EmergenciesHelper

  def emergency_state_label_html(emergency)
    # style the label tag based on the emergency state
    # classnames come from twitter bootstrap
    state_classnames = {
      'new' => 'label-info',
      'sending' => 'label-warning',
      'sent' => 'label-success',
      'failed' => 'label-important',
      'no_efars_nearby' => '' # default gray
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
      'sent' => 'label-warning',
      'en_route' => 'label-info',
      'on_scene' => 'label-success',
      'failed' => 'label-important'
    }
    content_tag :span, dispatch_message.state_message,
      :class => "label #{state_classnames[dispatch_message.state]}"
  end

  def detailed_datetime(dt)
    dt.in_time_zone("Africa/Johannesburg").strftime("%-I:%M %p - %d %b %y")
  end

end
