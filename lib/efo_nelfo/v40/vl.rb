module EfoNelfo
  module V40
    class VL < EfoNelfo::PostType
      property :post_type,         alias: :PostType,   limit: 2,   default: 'VL', required: true
      property :product_type,      alias: :VareMrk,    limit: 1,   type: :integer, required: true
      property :product_number,    alias: :VareNr,     limit: 14,  required: true
      property :name,              alias: :VaBetg,     limit: 30,  required: true
      property :description,       alias: :VaBetg2,    limit: 30
      property :unit,              alias: :MåleEnhet,  limit: 1,   type: :integer, required: true
      property :price_unit,        alias: :PrisEnhet,  limit: 3, required: true
      property :price_unit_desc,   alias: :PrisEnhetTxt, limit: 8
      property :price,             alias: :Pris,        limit: 10, type: :integer, required: true
      property :amount,            alias: :Mengde,    limit: 9, type: :integer, required: true
      property :price_date,        alias: :PrisDato,  limit: 8, type: :date, required: true
      property :status,            alias: :Status,    limit: 1, type: :integer, required: true
      property :block_number,      alias: :BlokkNummer, limit: 6, type: :integer
      property :discount_group,    alias: :RabattGruppe, limit: 14
      property :fabrication,       alias: :Fabrikat,  limit: 10
      property :type,              alias: :Type, limit: 10
      property :stocked,           alias: :Lagerført,   type: :boolean
      property :sales_package,     alias: :SalgsPakning, limit: 9, type: :integer
      property :discount,          alias: :Rabatt, limit: 4, type: :integer
      property :price_type,        alias: :Pristype, limit: 1
    end
  end
end
