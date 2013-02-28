#
# logic for models with a street address, or a township address

module Extensions

  module CapeTownLocation
    extend ActiveSupport::Concern

    included do

      # TODO improve location validation
      validates :township_house_number, :township_id, :presence => true, :if => :nil_geolocation?

      geocoded_by :formatted_address, :latitude => :lat, :longitude => :lng

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
        @readable_location = "#{township_house_number} #{township.name}" 
      else
        # remove city and country from the address
        @readable_location = "#{extract_street_and_house_number_from_formatted_address}"
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
      return str.split(',').reject { |s| s.include?("Cape Town") or s.include?("South Africa") }.compact.join(", ")
    end

  end

end