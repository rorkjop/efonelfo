require 'csv'

module EfoNelfo
  module V40
    module Reader
      module CSV
        class Base

          CSV_OPTIONS = {
            col_sep: ';',
            headers: false,
            row_sep: "\r\n",
            encoding: "iso-8859-1",
            quote_char: "\x00",
            force_quotes: true
          }

          attr_reader :csv

          def initialize(filename)
            @csv = ::CSV.open filename, CSV_OPTIONS
          end

          def parse
          end

        end
      end
    end
  end
end
