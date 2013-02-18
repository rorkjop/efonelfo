# encoding: utf-8
module EfoNelfo

  class Order::Head
    include EfoNelfo::Property

    attr_accessor :lines

    property :post_type,  limit: 8, type: String, required: true, alias: :PostType
    property :format,     limit: 8, type: String, required: true, alias: :Format
    property :version,    limit: 8, type: String, required: true, alias: :Versjon
    property :buyer_id,   limit: 8, type: String, required: true, alias: :KjøpersId

    def initialize(*args)
      @lines = []

      if args && args.first.is_a?(Array)
        parse(args.first)
      end
    end

    def parse(row)
      @post_type = row[0]
      @format    = row[1]
      @version   = row[2]
      @lines     = []
    end

    def post_type_human
      case post_type
        when 'BH' then 'Bestilling Hodepost'
        when 'IH' then 'Forespørsel Hodepost'
      end
    end

  end

end
