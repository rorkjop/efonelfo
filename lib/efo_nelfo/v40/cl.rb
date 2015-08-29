module EfoNelfo
  module V40
    class CL < EfoNelfo::PostType

      # It's important to list the property in the same order as specified in the specs
      property :post_type,                  alias: :PostType,       limit: 2,   default: post_type, required: true
      property :index_seller,               alias: :LinjeNrBekr,    limit: 4,   type: :integer
      property :index_buyer,                alias: :LinjeNrBe,      limit: 4,   type: :integer
      property :item_type,                  alias: :VareMrk,        limit: 1,   required: true, type: :integer
      property :item_number,                alias: :VareNr,         limit: 14,  required: true
      property :item_name,                  alias: :VaBetg,         limit: 30,  required: true
      property :item_description,           alias: :VaBetg2,        limit: 30
      property :item_quantity,              alias: :Ant,            limit: 9,   required: true, type: :integer
      property :item_delivered,             alias: :Lev,            limit: 9,   required: true, type: :integer
      property :item_remainder,             alias: :Rest,           limit: 9,   required: true, type: :integer
      property :price_unit,                 alias: :PrisEnhet,      limit: 3,   required: true
      property :buyer_item_number,          alias: :KVareNr,        limit: 25
      property :buyer_quantity,             alias: :KAnt,           limit: 9, type: :integer
      property :delivery_date,              alias: :LevDato,        type: :date
      property :delivery_date_remainder,    alias: :RLevDato,       type: :date
      property :unit_price,                 alias: :EnhetsPris,     type: :integer, limit: 10
      property :discount_percentage1,       alias: :Rab1P,          type: :integer, limit: 4
      property :discount_amount1,           alias: :Rab1Bel,        type: :integer, limit: 11
      property :discount_percentage2,       alias: :Rab2P,          type: :integer, limit: 4
      property :discount_amount2,           alias: :Rab2Bel,        type: :integer, limit: 11
      property :addition_percentage,        alias: :TilleggP,       type: :integer, limit: 4
      property :addition_amount,            alias: :TilleggBel,     type: :integer, limit: 11
      property :tax_percentage,             alias: :AvgiftP,        type: :integer, limit: 4
      property :tax_amount,                 alias: :AvgiftBel,      type: :integer, limit: 11
      property :amount,                     alias: :Beløp,          type: :integer, limit: 11
      property :buyers_ref,                 alias: :KjøpersRef,     limit: 25
      property :seller_warehouse_location,  alias: :SLagerMrk,      limit: 1
      property :seller_warehouse,           alias: :SLager,         limit: 14

      has_many :text, post_type: "CT"
    end
  end
end
