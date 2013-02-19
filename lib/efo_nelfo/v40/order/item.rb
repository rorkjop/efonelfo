module EfoNelfo
  module V40

    class Order::Item
      attr_accessor :type, :number, :name, :description

      def initialize(*args)
      	if args.first.is_a? Hash
  	      args.first.each do |attr, value|
  	        send "#{attr}=", value
  	      end
  	    end
      end
    end

  end
end
