# encoding: utf-8
module EfoNelfo
  class Order
    module V40
      class Head < EfoNelfo::PostType
        attr_accessor :lines
        attr_reader   :version, :format

        property :post_type,  limit: 8, type: String, required: true, alias: :PostType
        property :buyer_id,   limit: 8, type: String, required: true, alias: :KjøpersId

        def self.can_parse?(post_type, version)
          ['BH', 'IH'].include? post_type
        end

        def initialize(*args)
          @lines   = []
          @version = '4.0'
          @format  = 'EFONELFO'
          super
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
  end
end
