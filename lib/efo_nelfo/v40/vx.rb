module EfoNelfo
  module V40
    class VX < EfoNelfo::PostType
      property :post_type,  alias: :PostType, limit: 2,  default: post_type
      property :field,      alias: :FeltId,   limit: 10, required: true
      property :value,      alias: :Verdi,    limit: 70, required: true

      FIELD_MAPPINGS = {
        image:     "BILDE",
        weight:    "VEKT",
        dimension: "DIMENSJON",
        fdv:       "FDV",
        hms:       "HMS",
        volume:    "VOLUM"
      }

      FIELD_MAPPINGS.each do |key, field_value|
        # Add methods like def image?; field == 'BILDE'; end
        define_method "#{key}?" do
          field == field_value
        end

        # Add methods like: def image; value if image?; end
        define_method "#{key}" do
          self.value if send("#{key}?")
        end
      end

    end
  end
end
