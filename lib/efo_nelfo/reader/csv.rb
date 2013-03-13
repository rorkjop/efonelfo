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
        force_quotes: false,
        skip_blanks: true
      }

      attr_reader :csv, :data

      def initialize(options)
        if options[:filename]
          @data = File.read(options[:filename], encoding: CSV_OPTIONS[:encoding])
        else
          @data = options[:data]
        end

        raise EfoNelfo::IllegalEncoding if @data.encoding != Encoding::ISO_8859_1
        @csv = ::CSV.new @data, CSV_OPTIONS
      end

      def parse
        # Create the head object based on the first row
        head = parse_head csv.first
        head.source = @data

        # Read rest of the file and add them to the head
        csv.each do |row|
          # Find the correct posttype module for given posttype and version
          klass = EfoNelfo::PostType.for row[0]
          next if klass.nil?

          line = initialize_object_with_properties klass, row
          head.add line
        end

        head
      end

      private

      def parse_head(row)
        klass = EfoNelfo::PostType.for row[0], row[2]
        raise EfoNelfo::UnsupportedPostType.new("Don't know how to handle v#{row[2]} of #{row[0]}") if klass.nil?

        initialize_object_with_properties klass, row
      end

      def initialize_object_with_properties(klass, columns)
        object = klass.new
        object.class.properties.each_with_index do |property, i|
          object.send "#{property.first}=", columns[i]
        end
        object
      end

    end

  end
end
