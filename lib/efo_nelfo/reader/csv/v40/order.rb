module EfoNelfo
  module Reader
    module CSV
      module V40

        class Order < EfoNelfo::Reader::CSV::Base

          def self.supported_file?(filename)
            File.basename(filename)[0] == 'B'
          end

          def parse
            # Create the post type based on the first row
            object = parse_head csv.first

            # Read rest of the file
            csv.each do |row|
              klass = EfoNelfo.post_type_for(row[0], row[1])
              next if klass.nil?

              line = klass.new
              line.class.properties.each_with_index do |property, i|
                line.send "#{property.first}=", row[i+1]
              end

              object.add line
            end

            object
          end

          def parse_head(row)
            klass = EfoNelfo.post_type_for(row[0], row[1])
            raise UnsupportedPostType.new("Don't know how to handle #{row[0]}") if klass.nil?

            object = klass.new #EfoNelfo::V40::Order.new
            object.class.properties.each_with_index do |property, i|
              object.send "#{property.first}=", row[i+3]
            end
            object
          end

        end

      end
    end
  end
end
