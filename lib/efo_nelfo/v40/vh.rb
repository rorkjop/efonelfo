module EfoNelfo
  module V40
    class VH < EfoNelfo::PostType
      include PostHeadType

      property :seller_id,          alias: :SelgersId,     limit: 14, required: true
      property :buyer_id,           alias: :KjøpersId,     limit: 14
      property :customer_id,        alias: :KundeNr,       limit: 10
      property :from_date,          alias: :FraDato,       limit: 8, type: :date
      property :to_date,            alias: :TilDato,       limit: 8, type: :date
      property :currency,           alias: :Valuta,        limit: 3, required: true
      property :contract_id,        alias: :AvtaleId,      limit: 10
      property :seller_name,        alias: :SFirmaNavn,    limit: 35, required: true
      property :seller_address1,    alias: :SAdr1,         limit: 35
      property :seller_address2,    alias: :SAdr2,         limit: 35
      property :seller_zip,         alias: :SPostNr,       limit: 9, required: true
      property :seller_office,      alias: :SPostSted,     limit: 35, required: true
      property :seller_country,     alias: :SLandK,        limit: 2
      property :price_type,         alias: :PrisType,      limit: 1

      has_many :lines, post_type: 'VL'
    end
  end
end
