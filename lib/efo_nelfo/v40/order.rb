# encoding: utf-8
module EfoNelfo

  module V40

    class Order
      attr_accessor :heads

      def initialize
        @heads = []
      end

      def parse(csv)
        csv.each do |row|
          case row[0]
          when 'BH'
            @heads << Order::Head.new(row)
          when 'BL'
            @heads.last.lines << Order::Line.new(row)
          end
        end
      end
    end

  end

end
