#
# logic for models with a street address, or a township address

module Extensions

  module CapeTownLocation
    extend ActiveSupport::Concern

    included do

      geocoded_by :formatted_address, :latitude => :lat, :longitude => :lng

      validate :township_or_address_must_be_present

    end

    def nil_geolocation?
      lng.blank? or lat.blank?
    end

    def has_geolocation?
      lng.present? and lat.present?
    end

    def readable_location
      return @readable_location if @readable_location.present?
      @readable_location = ""
      if township_id.present?
        @readable_location = [township_house_number, township.name].compact.join(" ") 
      else
        if self.respond_to?(:input_address)
          @readable_location = "#{input_address}"
        else
          # remove city and country from the address
          @readable_location = "#{extract_street_and_house_number_from_formatted_address}"
        end
      end
      if self.respond_to?(:landmarks) and landmarks.present?
        @readable_location += " (#{landmarks})"
      end
      return @readable_location
    end

    def extract_street_and_house_number_from_formatted_address
      # removes the city and country from a formatted address
      # returns just the street and house number
      str = self.formatted_address
      return nil if str.blank?
      return str.split(',').reject { |s| s.include?("Cape Town") or s.include?("South Africa") }.compact.join(", ")
    end

    def township_or_address_must_be_present
      if nil_geolocation? and self.township_id.blank?
        errors.add :location, "cannot be blank"
      end
    end

  end

end