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
        property :text,  alias: :FriTekst,  limit: 30

      end
    end
  end
end
