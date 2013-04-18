#
# logic for models with a street address, or a township address

module Extensions

  module CapeTownLocation
    extend ActiveSupport::Concern

    included do
      geocoded_by :formatted_address, :latitude => :lat, :longitude => :lng

      scope :has_geolocation, where('lat is not null AND lng is not null')
    end

    def has_geolocation?
      lng.present? and lat.present?
    end

  end

end