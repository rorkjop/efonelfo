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
          @data = options[:data].force_encoding ENCODING
        end

        @csv = ::CSV.new @data, CSV_OPTIONS
      end

      # Parses the data and returns an EfoNelfo object of some kind
      def parse
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
        return @first if @first
        csv.rewind
        @first = csv.first
      end

      def head
        return @head if @head
        klass = EfoNelfo::PostType.for first[0], first[2]
        raise EfoNelfo::UnsupportedPostType.new("Don't know how to handle v#{first[2]} of #{first[0]}") if klass.nil?
        @head = klass.new first
      end

    end

  end
end
