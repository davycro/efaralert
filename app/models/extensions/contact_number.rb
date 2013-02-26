module Extensions

  module ContactNumber
    extend ActiveSupport::Concern


    module InstanceMethods

      def readable_contact_number
        cn = self.contact_number
        "+#{cn[0..1]} #{cn[2..3]} #{cn[4..6]} #{cn[7..-1]}"
      end

    end

  end

end