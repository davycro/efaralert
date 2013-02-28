module Extensions

  module ContactNumber
    extend ActiveSupport::Concern

    included do
      before_validation :format_contact_number_for_south_africa
    end


    def readable_contact_number
      cn = self.contact_number
      # replace the country code with a 0
      "0#{cn[2..3]} #{cn[4..6]} #{cn[7..-1]}"
    end

    def format_contact_number_for_south_africa
      return false if contact_number.blank?
      country_code = "27"
      num = self.contact_number.to_s
      if num.length < 9
        errors.add(:contact_number, "must be at least nine digits")
        return false
      end
      if num[0..1] == country_code
        return true
      end
      if num[0] == "0"
        num = num[1..-1]
      end
      self.contact_number = "#{country_code}#{num}"
      return true
    end

    def send_text_message(message)
      return SMS_API.send_message(self.contact_number, message)
    end

  end

end