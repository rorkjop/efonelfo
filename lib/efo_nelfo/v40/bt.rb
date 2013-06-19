module EfoNelfo
  module V40
    class BT < EfoNelfo::PostType

      # It's important to list the property in the same order as specified in the specs
      property :post_type, alias: :PostType, limit: 2, default: post_type, required: true
      property :text,      alias: :FriTekst, limit: 30

      def to_s
        text
      end

    end
  end
end
