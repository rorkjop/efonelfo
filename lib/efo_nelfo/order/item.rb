module EfoNelfo

  class Order::Item
    attr_accessor :type, :number, :name, :description

    def initialize(args)
      args.each do |attr, value|
        send "#{attr}=", value
      end
    end

  end

end
