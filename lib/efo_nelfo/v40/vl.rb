module EfoNelfo
  module V40
    class VL < EfoNelfo::PostType
      property :post_type,         alias: :PostType,      limit: 2,  default: post_type, required: true
      property :product_type,      alias: :VareMrk,       limit: 1,  type: :integer, required: true
      property :product_number,    alias: :VareNr,        limit: 14, required: true
      property :name,              alias: :VaBetg,        limit: 30, required: true
      property :description,       alias: :VaBetg2,       limit: 30
      property :unit,              alias: :MåleEnhet,     limit: 1,  type: :integer, required: true
      property :price_unit,        alias: :PrisEnhet,     limit: 3,  required: true
      property :price_unit_desc,   alias: :PrisEnhetTxt,  limit: 8
      property :price,             alias: :Pris,          limit: 10, decimals: 2, type: :integer, required: true
      property :amount,            alias: :Mengde,        limit: 9,  type: :integer, required: true
      property :price_date,        alias: :PrisDato,      limit: 8,  type: :date, required: true
      property :status,            alias: :Status,        limit: 1,  type: :integer, required: true
      property :block_number,      alias: :BlokkNummer,   limit: 6,  type: :integer
      property :discount_group,    alias: :RabattGruppe,  limit: 14
      property :fabrication,       alias: :Fabrikat,      limit: 10
      property :type,              alias: :Type,          limit: 10
      property :stocked,           alias: :Lagerført,     type: :boolean
      property :sales_package,     alias: :SalgsPakning,  limit: 9,  type: :integer
      property :discount,          alias: :Rabatt,        limit: 4,  type: :integer
      property :price_type,        alias: :Pristype,      limit: 1

      has_many :info, post_type: "VX"
      has_many :alternatives, post_type: "VA"

      def nrf_id
        product_type == 4 ? product_number : nil
      end

      def gross_price?
        price_type.nil? || price_type == 'B'
      end

      def gross_price
        gross_price? ? properties[:price].to_f : nil
      end

      def net_price
        net_price? ? properties[:price].to_f : nil
      end

      def net_price?
        price_type == 'N'
      end

      def images
        info.map(&:image).compact
      end

      [ :weight, :dimension, :volume, :fdv, :hms ].each do |key|
        define_method key do
          fetch_from_info key
        end
      end

      # Returns array of urls extracted from VX lines
      def urls
        info.map(&:value).select { |u| u.match %r{\Ahttps?://} }
      end

      private

      def fetch_from_info(method)
        vx = info.select(&"#{method}?".to_sym).compact.first
        vx && vx.send(method)
      end
    end
  end
end
