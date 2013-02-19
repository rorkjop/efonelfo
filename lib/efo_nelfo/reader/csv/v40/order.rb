module EfoNelfo
  module Reader
    module CSV
      module V40

        class Order < EfoNelfo::Reader::CSV::Base

          def self.supported_file?(filename)
            File.basename(filename)[0] == 'B'
            # ['.csv', '.txt'].include?(File.basename(filename))
          end

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
