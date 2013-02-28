module Extensions

  module ReadableTimestamps
    extend ActiveSupport::Concern

    def readable_timestamps
      if @readable_timestamps.present?
        return @readable_timestamps
      end

      data = {}
      [:created_at, :updated_at].each do |key|
        data[key] = {
          :military_time => self[key].strftime("%Hh%M"),
          :short_date => self[key].strftime("%d %b %y")
        }
      end
      @readable_timestamps = data
      return @readable_timestamps
    end
    
  end

end