# encoding: utf-8

# Common stuff
require 'efo_nelfo/version'
require 'efo_nelfo/errors'
require 'efo_nelfo/array'
require 'efo_nelfo/attribute_assignment'
require 'efo_nelfo/property'
require 'efo_nelfo/post_type'
require 'efo_nelfo/post_head_type'

# EfoNelfo v4.0 modules
require 'efo_nelfo/v40/bh'
require 'efo_nelfo/v40/bl'
require 'efo_nelfo/v40/bt'
require 'efo_nelfo/v40/vh'
require 'efo_nelfo/v40/vl'
require 'efo_nelfo/v40/vx'
require 'efo_nelfo/v40/va'

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

