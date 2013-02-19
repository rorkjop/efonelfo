# encoding: utf-8
require 'csv'

require 'pry-debugger'

require 'efo_nelfo/version'
require 'efo_nelfo/attribute_assignment'
require 'efo_nelfo/property'
require 'efo_nelfo/post_type'
require 'efo_nelfo/order'

module EfoNelfo
  class UnsupportedVersion < StandardError; end
  class UnsupportedPostType < StandardError; end
  class UnknownFileType < StandardError; end

  CSV_OPTIONS = {
    col_sep: ';',
    headers: false,
    row_sep: "\r\n",
    encoding: "iso-8859-1",
    quote_char: "\x00",
    force_quotes: true
  }

  class << self
    def parse(filename)
      case File.basename(filename)[0]
        when "B" then model = Order.new
      else
        raise UnknownFileType.new "Don't know how to parse '#{filename}'"
      end

      csv = CSV.open filename, CSV_OPTIONS
      model.parse csv
      model
    end

    def post_type_for(type, version)
      EfoNelfo::PostType.for type, version
    end

  end


end
