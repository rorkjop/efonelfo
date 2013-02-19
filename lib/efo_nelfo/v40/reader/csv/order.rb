module EfoNelfo
  module V40
    module Reader
      module CSV

        class Order < Base

          def parse
            row = csv.first

            order = EfoNelfo::V40::Order.new
            order.class.properties.each_with_index do |property, i|
              order.send "#{property.first}=", row[i+3]
            end

            csv.each do |row|
              line = EfoNelfo::V40::Order::Line.new
              line.class.properties.each_with_index do |property, i|
                line.send "#{property.first}=", row[i+1]
              end

              order.add line
            end

            order
          end

        end

      end
    end
  end
end
