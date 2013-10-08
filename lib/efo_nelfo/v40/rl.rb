module EfoNelfo
  module V40
    class RL < EfoNelfo::PostType
      property :post_type,         alias: :PostType,      limit: 2,  default: post_type, required: true
      property :product_type,      alias: :VareMrk,       limit: 1,  type: :integer, required: true
      property :product_number,    alias: :VareNr,        limit: 14, required: true
      property :price,             alias: :AvtaltPris,    limit: 10, type: :integer, decimals: 2
      property :discount,          alias: :Rabatt,        limit: 2,  required: true, type: :integer, decimals: 2
      property :text,              alias: :Tekst,         limit: 30
    end
  end
end
