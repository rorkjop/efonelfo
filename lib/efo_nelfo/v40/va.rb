module EfoNelfo
  module V40
    class VA < PostType
      property :post_type,      alias: :PostType,     limit: 2, required: true, default: post_type
      property :product_type,   alias: :VareMrk,      limit: 1, type: :integer, required: true
      property :product_number, alias: :VareNr,       limit: 14, required: true
      property :type,           alias: :VaType,       limit: 1, required: true
      property :sales_package,  alias: :SalgsPakning, limit: 9, type: :integer

      def nrf_id
        product_type == 4 && product_number.strip
      end

      def replacement?
        type == 'E'
      end

      def alternative?
        type == 'A'
      end

      def alternative_id?
        type == 'V'
      end

      def package_size?
        type == 'P'
      end

    end
  end
end
