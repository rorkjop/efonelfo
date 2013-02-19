# encoding: utf-8
module EfoNelfo

  class Order::Line < EfoNelfo::PostType
    attr_accessor :post_type, :line_no, :order_ref, :item, :count, :price_unit, :buyer_item_no, :delivery_date, :buyer_ref, :splitable, :replacable

    def self.can_parse?(type, version)
      type == "BL"
    end

    def initialize(*args)
      if args && args.first.is_a?(Array)
        parse args.first
      elsif args && args.first.is_a?(Hash)
        args.first.each do |attr, value|
          send "#{attr}=", value
        end
      end
    end

    def parse(row)
      @post_type      = row[0]
      @line_no        = row[1]
      @order_ref      = row[2]
      @item           = Order::Item.new type: row[3], number: row[4], name: row[5], description: row[6]
      @count          = row[7].to_f / 100
      @price_unit     = row[8]
      @buyer_item_no  = row[9]
      @delivery_date  = Date.parse row[10]
      @buyer_ref      = row[11]
      @splitable      = boolean row[12]
      @replacable     = boolean row[13]
    end

    def post_type_human
      case post_type
      when 'BL' then 'Bestilling vareLinjepost'
      when 'IL' then 'Forespørsel vareLinjepost'
      end
    end

    private

    def boolean(input)
      input.nil? || input == 'J'
    end

  end
end
