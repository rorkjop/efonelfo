module EfoNelfo
  class Order

    module V40

      class Item
        include EfoNelfo::AttributeAssignment
        include EfoNelfo::Property

        property :type,        required: true
        property :number,      required: true
        property :name,        required: true
        property :description

        def initialize(*args)
          initialize_attributes *args
        end
      end

    end
  end

end
