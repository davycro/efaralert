class CommunityCenter < ActiveRecord::Base
  attr_accessible :street, :city, :country, :name, :postal_code, :province, :suburb

  validates :street, :city, :country, :name, :postal_code,
    :presence => true

  # converts street into one string
  def location_summary
    if @location_summary.present?
      return @location_summary
    end

    @location_summary = self.street
    if self.suburb.present?
      @location_summary += ", #{self.suburb}"
    end
    @location_summary += ", #{self.city} #{self.postal_code}"
    if self.province.present?
      @location_summary += ", #{self.province}"
    end
    @location_summary += ", #{self.country}"

    return @location_summary
  end
end
