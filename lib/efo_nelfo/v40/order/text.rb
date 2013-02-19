# encoding: utf-8
module EfoNelfo
  module V40
    class Text < EfoNelfo::PostType
      VERSION = "4.0"

      # It's important to list the property in the same order as specified in the specs
      property :text,  alias: :FriTekst,  limit: 30

      def self.can_parse?(post_type, version)
        ['BH', 'IH'].include?(post_type) #&& version == VERSION
      end

      def post_type_human
        case post_type
          when 'BT' then 'Bestilling Fritekstlinje'
          when 'IT' then 'Forespørsel Fritekstlinje'
        end
      end
    end
  end
end
