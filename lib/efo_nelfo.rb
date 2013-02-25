# encoding: utf-8

# Common stuff
require 'efo_nelfo/version'
require 'efo_nelfo/errors'
require 'efo_nelfo/array'
require 'efo_nelfo/attribute_assignment'
require 'efo_nelfo/property'
require 'efo_nelfo/post_type'

# EfoNelfo v4.0 modules
require 'efo_nelfo/v40/order/order'
require 'efo_nelfo/v40/order/line'
require 'efo_nelfo/v40/order/text'

# Reader modules (import)
require 'efo_nelfo/reader/csv'

module EfoNelfo

  class << self

    def load(filename)
      Reader::CSV.new(filename: filename).parse
    end

    def parse(data)
      Reader::CSV.new(data: data).parse
    end

  end


end

