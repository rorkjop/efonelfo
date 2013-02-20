# encoding: utf-8
module EfoNelfo
  module V40
    class Order < EfoNelfo::PostType
      POST_TYPES = {
        'BH' => 'Bestilling Hodepost',
        'IH' => 'Forespørsel Hodepost'
      }

      attr_reader   :version, :format, :lines
      attr_accessor :source

      # It's important to list the property in the same order as specified in the specs
      property :seller_id,                   alias: :SelgersId,     limit: 14
      property :buyer_id,                    alias: :KjøpersId,     limit: 14, required: true
      property :order_number,                alias: :BestNr,        limit: 10, required: true
      property :customer_id,                 alias: :KundeNr,       limit: 10, required: true
      property :contract_type,               alias: :AvtaleIdMrk,   limit: 1, type: Integer
      property :contract_id,                 alias: :AvtaleId,      limit: 10
      property :buyer_order_number,          alias: :KOrdNr,        limit: 10
      property :buyer_customer_id,           alias: :KundAvd,       limit: 10
      property :project_id,                  alias: :ProsjektNr,    limit: 10
      property :buyer_warehouse_location,    alias: :KLagerMrk,     limit: 1
      property :buyer_warehouse,             alias: :KLager,        limit: 14
      property :seller_warehoure_location,   alias: :SLagerMrk,     limit: 1
      property :seller_warehouse,            alias: :SLager,        limit: 14
      property :external_ref,                alias: :EksternRef,    limit: 36
      property :buyer_ref,                   alias: :KjøpersRef,    limit: 25
      property :label,                       alias: :Merket,        limit: 25
      property :confirmation_type,           alias: :ObkrType,      limit: 2
      property :transport_type,              alias: :TransportMåte, limit: 25
      property :transport_msg,               alias: :Melding,       limit: 25
      property :delivery_date,               alias: :LevDato,       type: Date
      property :origin,                      alias: :BestOpp,       limit: 2

      property :receiver_delivery_location,  alias: :LAdrLok,       limit: 14
      property :receiver_name,               alias: :LFirmaNavn,    limit: 35
      property :receiver_address1,           alias: :LAdr1,         limit: 35
      property :receiver_address2,           alias: :LAdr2,         limit: 35
      property :receiver_zip,                alias: :LPostNr,       limit: 9
      property :receiver_office,             alias: :LPostSted,     limit: 35
      property :receiver_country,            alias: :LLandK,        limit: 2

      property :buyer_name,                  alias: :KFirmaNavn,    limit: 35
      property :buyer_address1,              alias: :KAdr1,         limit: 35
      property :buyer_address2,              alias: :KAdr2,         limit: 35
      property :buyer_zip,                   alias: :KPostNr,       limit: 9
      property :buyer_office,                alias: :KPostSted,     limit: 35
      property :buyer_country,               alias: :KLandK,        limit: 2
      property :buyer_email,                 alias: :KEPost,        limit: 60
      property :buyer_web,                   alias: :KWebAdr,       limit: 40

      property :seller_name,                 alias: :SFirmaNavn,    limit: 35
      property :seller_address1,             alias: :SAdr1,         limit: 35
      property :seller_address2,             alias: :SAdr2,         limit: 35
      property :seller_zip,                  alias: :SPostNr,       limit: 9
      property :seller_office,               alias: :SPostSted,     limit: 35
      property :seller_country,              alias: :SLandK,        limit: 2


      def initialize(*args)
        super
        @format    = 'EFONELFO'
        @lines     = []
      end

      def add(post_type)
        case
        when post_type.is_a?(Order::Line)
          post_type.index = lines.length + 1
          lines << post_type
        when post_type.is_a?(Order::Text)
          lines.last.text = post_type.text
        end
      end

    end
  end
end
