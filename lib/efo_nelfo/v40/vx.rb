module EfoNelfo
  module V40
    class VX < EfoNelfo::PostType
      property :post_type,  alias: :PostType, limit: 2,  default: post_type
      property :field,      alias: :FeltId,   limit: 10, required: true
      property :value,      alias: :Verdi,    limit: 70, required: true
    end
  end
end
