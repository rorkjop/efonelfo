# encoding: utf-8
require 'csv'
require 'pry-debugger'

require_relative 'efo_nelfo/version'
require_relative 'efo_nelfo/order'
require_relative 'efo_nelfo/order/head'
require_relative 'efo_nelfo/order/line'
require_relative 'efo_nelfo/order/item'

module EfoNelfo
  CSV_OPTIONS = {
    col_sep: ';',
    headers: false,
    row_sep: "\r\n",
    encoding: "iso-8859-1",
    quote_char: "\x00",
    force_quotes: true
  }

  def self.parse(filename)
    case File.basename(filename)[0]
    when "B" then model = Order.new
    else
      raise "Unknown filetype: #{filename}"
    end

    csv = CSV.open filename, CSV_OPTIONS
    model.parse csv
    model
  end

end
