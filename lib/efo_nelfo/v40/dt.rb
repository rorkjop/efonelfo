module EfoNelfo
  module V40
    class DT < EfoNelfo::PostType
      property :post_type, alias: :PostType, limit: 2, default: post_type, required: true
      property :text,      alias: :FriTekst, limit: 30

      def to_s
        text
      end
    end
  end
end
