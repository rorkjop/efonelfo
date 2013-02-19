# encoding: utf-8
module EfoNelfo
  class Order

    module V40

      class Line < EfoNelfo::PostType
        # attr_accessor :post_type, :line_no, :order_ref, :item, :count, :price_unit, :buyer_item_no, :delivery_date, :buyer_ref, :splitable, :replacable

        property :post_type
        property :line_no
        property :order_ref
        property :item
        property :count
        property :price_unit
        property :buyer_item_no
        property :delivery_date
        property :buyer_ref
        property :splitable
        property :replacable

        def self.can_parse?(post_type, version)
          ['BL', 'IL'].include? post_type
        end

        def parse(row)
          @post_type      = row[0]
          @line_no        = row[1]
          @order_ref      = row[2]
          @item           = Item.new type: row[3], number: row[4], name: row[5], description: row[6]
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
  end
end
