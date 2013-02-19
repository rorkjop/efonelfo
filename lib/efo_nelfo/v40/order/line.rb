# encoding: utf-8
module EfoNelfo
  module V40
    class Order
      class Line < EfoNelfo::PostType
        POST_TYPES = {
          'BL' => 'Bestilling vareLinjepost',
          'IL' => 'Forespørsel vareLinjepost'
        }

        # It's important to list the property in the same order as specified in the specs
        property :index,             alias: :LinjeNr,    limit: 4,   type: Integer
        property :order_number,      alias: :BestNr,     limit: 10,  required: true
        property :item_type,         alias: :VareMrk,    limit: 1,   required: true, type: Integer
        property :item_number,       alias: :VareNr,     limit: 14,  required: true
        property :item_name,         alias: :VaBetg,     limit: 30,  required: true
        property :item_description,  alias: :VaBetg2,    limit: 30
        property :item_count,        alias: :Ant,        limit: 9,   required: true, type: Integer
        property :price_unit,        alias: :PrisEnhet,  limit: 3,   required: true
        property :buyer_item_number, alias: :KVareNr,    limit: 25
        property :delivery_date,     alias: :LevDato,    type: Date
        property :buyer_ref,         alias: :KjøpersRef, limit: 25
        property :splitable,         alias: :DelLev,     type: :Boolean, default: true
        property :replacable,        alias: :AltKode,    type: :Boolean, default: true

        attr_accessor :text
      end

    end
  end
end
