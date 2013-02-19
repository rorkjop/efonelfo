require 'csv'

module EfoNelfo
  module Reader
    module CSV
      class Base

        @modules = []

        CSV_OPTIONS = {
          col_sep: ';',
          headers: false,
          row_sep: "\r\n",
          encoding: "iso-8859-1",
          quote_char: "\x00",
          force_quotes: true
        }

        attr_reader :csv

        class << self
          def inherited(klass)
            @modules << klass
          end

          def find_module_for(filename)
            @modules.select { |mod| mod.supported_file?(filename) }.first
          end
        end

        def initialize(filename)
          @csv = ::CSV.open filename, CSV_OPTIONS
        end

        def parse
        end

      end
    end
  end
end
