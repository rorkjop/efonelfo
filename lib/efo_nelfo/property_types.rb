module EfoNelfo
  module PropertyTypes
    refine NilClass do
      def to_csv
        nil
      end
    end

    refine TrueClass do
      def to_csv
        'J'
      end
    end

    refine FalseClass do
      def to_csv
        'N'
      end
    end

    refine String do
      def to_csv
        to_s.encode EfoNelfo::Reader::CSV::ENCODING
      end
    end

    refine Date do
      def to_csv
        strftime("%Y%m%d")
      end
    end

    refine Fixnum do
      def to_csv
        to_i
      end
    end

    refine Float do
      def with_decimals(decimals)
        decimals.nil? ? self : self * (1.0/10**decimals.to_i)
      end
    end

  end

end
