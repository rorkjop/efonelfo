module EfoNelfo
  module V40
    class BL < EfoNelfo::PostType

      # It's important to list the property in the same order as specified in the specs
      property :post_type,         alias: :PostType,   limit: 2,   default: post_type, required: true
      property :index,             alias: :LinjeNr,    limit: 4,   type: :integer
      property :order_number,      alias: :BestNr,     limit: 10,  required: true
      property :item_type,         alias: :VareMrk,    limit: 1,   required: true, type: :integer
      property :item_number,       alias: :VareNr,     limit: 14,  required: true
      property :item_name,         alias: :VaBetg,     limit: 30,  required: true
      property :item_description,  alias: :VaBetg2,    limit: 30
      property :item_count,        alias: :Ant,        limit: 9,   required: true, type: :integer
      property :price_unit,        alias: :PrisEnhet,  limit: 3,   required: true
      property :buyer_item_number, alias: :KVareNr,    limit: 25
      property :delivery_date,     alias: :LevDato,    type: :date
      property :buyer_ref,         alias: :KjøpersRef, limit: 25
      property :splitable,         alias: :DelLev,     type: :boolean, default: true
      property :replacable,        alias: :AltKode,    type: :boolean, default: true

      has_many :text, post_type: "BT"

      # Returns an array with one or more elements
      def to_a
        [ super, text.to_a ].reject(&:empty?)
      end

      def format_item_count
        item_count ? item_count * 100 : nil
      end

    end

  end
end
