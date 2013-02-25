# encoding: utf-8
module EfoNelfo
  module V40
    class Order
      class Text < EfoNelfo::PostType
        POST_TYPES = {
          'BT' => 'Bestilling Fritekstlinje',
          'IT' => 'Forespørsel Fritekstlinje'
        }

        # It's important to list the property in the same order as specified in the specs
        property :post_type, alias: :PostType, limit: 2, default: 'BT'
        property :text,      alias: :FriTekst, limit: 30

        def to_s
          text
        end

      end
    end
  end
end
