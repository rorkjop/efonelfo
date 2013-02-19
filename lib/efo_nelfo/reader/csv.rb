require 'csv'

module EfoNelfo
  module Reader

    class CSV
      CSV_OPTIONS = {
        col_sep: ';',
        headers: false,
        row_sep: "\r\n",
        encoding: "iso-8859-1",
        quote_char: "\x00",
        force_quotes: true
      }

      attr_reader :csv

      def self.supported_file?(filename)
        File.basename(filename)[0] == 'B'
      end

      def initialize(filename)
        @csv = ::CSV.open filename, CSV_OPTIONS
      end

      def parse
        # Create the head object based on the first row
        head = parse_head csv.first

        # Read rest of the file and add them to the head
        csv.each do |row|
          # Find the correct posttype module for given posttype and version
          klass = find_post_type row
          next if klass.nil?

          line = initialize_object_with_properties klass, row, 1
          head.add line
        end

        head
      end

      private

      def find_post_type(row)
        EfoNelfo::PostType.for(row[0], row[1])
      end

      def parse_head(row)
        klass = find_post_type row
        raise UnsupportedPostType.new("Don't know how to handle #{row[0]}") if klass.nil?

        initialize_object_with_properties klass, row, 3
      end

      def initialize_object_with_properties(klass, columns, offset)
        object = klass.new
        object.class.properties.each_with_index do |property, i|
          object.send "#{property.first}=", columns[i+offset]
        end
        object
      end

    end

  end
end
