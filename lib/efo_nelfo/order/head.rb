# encoding: utf-8
module EfoNelfo

  class Order::Head
    attr_accessor :lines, :post_type, :version, :format

    def initialize(row)
      @post_type = row[0]
      @format    = row[1]
      @version   = row[2]
      @lines     = []
    end

    def post_type_human
      case post_type
        when 'BH' then 'Bestilling Hodepost'
        when 'IH' then 'Forespørsel Hodepost'
      end
    end

  end

end
