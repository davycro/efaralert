module Admin::AdminsHelper
  def horizontal_text_field(record, record_attribute, locals={})

    locals[:record] = record
    locals[:record_attribute] = record_attribute
    locals[:label] ||= record_attribute.to_s.titleize
    locals[:placeholder] ||= ""

    render :partial => "admin/shared/horizontal_text_field", 
      :locals => locals
  end

  def horizontal_password_field(record, locals={})
    locals[:record] = record

    render :partial => "admin/shared/horizontal_password_field",
      :locals => locals
  end

end
