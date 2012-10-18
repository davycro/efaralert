class CommunityCenter < ActiveRecord::Base
  attr_accessible :address, :city, :country, :name, :postal_code, :province, :suburb

  validates :address, :city, :country, :name, :postal_code,
    :presence => true

  # converts address into one string
  def location_summary
    if @location_summary.present?
      return @location_summary
    end

    @location_summary = self.address
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
