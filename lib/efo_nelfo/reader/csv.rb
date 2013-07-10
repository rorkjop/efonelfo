require 'csv'

module EfoNelfo
  module Reader

    class CSV
      ENCODING = Encoding::ISO_8859_1

      CSV_OPTIONS = {
        col_sep: ';',
        headers: false,
        row_sep: "\r\n",
        quote_char: "\x00",
        force_quotes: false,
        skip_blanks: true
      }

      attr_reader :csv, :data

      def initialize(options)
        if options[:filename]
          @data = File.read(options[:filename], encoding: ENCODING)
        else
          @data = options[:data]
        end

        @csv = ::CSV.new @data, CSV_OPTIONS
      end

      def parse
        # Create the head object based on the first row
        head = parse_head first

        # Read rest of the file and add them to the head
        csv.each do |row|
          # Find the correct posttype module for given posttype and version
          klass = EfoNelfo::PostType.for row[0], head.version
          next if klass.nil?

          head.add klass.new(row)
        end

        head
      end

      # Returns the first row of the csv file
      def first
        csv.first
      end

      private

      def parse_head(row)
        klass = EfoNelfo::PostType.for row[0], row[2]
        raise EfoNelfo::UnsupportedPostType.new("Don't know how to handle v#{row[2]} of #{row[0]}") if klass.nil?
        klass.new row
      end

    end

  end
end
