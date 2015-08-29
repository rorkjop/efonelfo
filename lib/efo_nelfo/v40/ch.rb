module EfoNelfo
  module V40
    class CH < EfoNelfo::PostType
      include PostHeadType

      # It's important to list the property in the same order as specified in the specs
      property :seller_id,                   alias: :SelgersId,      limit: 14, required: true
      property :buyer_id,                    alias: :KjøpersId,      limit: 14
      property :production_date,             alias: :ProdDato,       limit: 8,  required: true, type: :date
      property :confirmation_number,         alias: :BekreftelsesNr, limit: 13, required: true
      property :seller_order_number,         alias: :SOrdNr,         limit: 10
      property :order_number,                alias: :BestNr,         limit: 10
      property :customer_id,                 alias: :KundeNr,        limit: 10, required: true
      property :contract_type,               alias: :AvtaleIDMrk,    limit: 1
      property :contract_id,                 alias: :AvtaleID,       limit: 10
      property :buyer_order_number,          alias: :KOrdNr,         limit: 10
      property :buyer_customer_id,           alias: :KundAvd,        limit: 10
      property :project_id,                  alias: :ProsjektNr,     limit: 10
      property :buyer_warehouse_location,    alias: :KLagerMrk,      limit: 1
      property :buyer_warehouse,             alias: :KLager,         limit: 14
      property :external_ref,                alias: :EksternRef,     limit: 10
      property :buyer_ref,                   alias: :KjøpersRef,     limit: 25
      property :seller_ref,                  alias: :SelgersRef,     limit: 25
      property :label,                       alias: :Merket,         limit: 25
      property :transport_type,              alias: :TransportMåte,  limit: 25
      property :transport_msg,               alias: :Melding,        limit: 25
      property :delivery_date,               alias: :LevDato,        type: :date
      property :origin,                      alias: :BestOpp,        limit: 2

      property :receiver_delivery_location,  alias: :LAdrLok,       limit: 14
      property :receiver_name,               alias: :LFirmaNavn,    limit: 35
      property :receiver_address1,           alias: :LAdr1,         limit: 35
      property :receiver_address2,           alias: :LAdr2,         limit: 35
      property :receiver_zip,                alias: :LPostNr,       limit: 9
      property :receiver_office,             alias: :LPostSted,     limit: 35
      property :receiver_country,            alias: :LLandK,        limit: 2

      property :buyer_company_name,          alias: :KFirmaNavn,    limit: 35
      property :buyer_address1,              alias: :KAdr1,         limit: 35
      property :buyer_address2,              alias: :KAdr2,         limit: 35
      property :buyer_zip,                   alias: :KPostNr,       limit: 9
      property :buyer_office,                alias: :KPostSted,     limit: 35
      property :buyer_country,               alias: :KLandK,        limit: 2
      property :buyer_name,                  alias: :KNavn,         limit: 35

      property :billing_company_name,        alias: :FFirmaNavn,    limit: 35
      property :billing_address1,            alias: :FAdr1,         limit: 35
      property :billing_address2,            alias: :FAdr2,         limit: 35
      property :billing_zip,                 alias: :FPostNr,       limit: 9
      property :billing_office,              alias: :FPostSted,     limit: 35
      property :billing_country,             alias: :FLandK,        limit: 2

      property :seller_company_name,         alias: :SFirmaNavn,    limit: 35
      property :seller_address1,             alias: :SAdr1,         limit: 35
      property :seller_address2,             alias: :SAdr2,         limit: 35
      property :seller_zip,                  alias: :SPostNr,       limit: 9
      property :seller_office,               alias: :SPostSted,     limit: 35
      property :seller_country,              alias: :SLandK,        limit: 2
      property :currency,                    alias: :Valuta,        limit: 3

      has_many :lines, post_type: "CL"
    end
  end
end
