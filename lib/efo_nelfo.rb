# encoding: utf-8

# Common stuff
require 'efo_nelfo/version'
require 'efo_nelfo/errors'
require 'efo_nelfo/property_types'
require 'efo_nelfo/property'
require 'efo_nelfo/properties'
require 'efo_nelfo/collection'
require 'efo_nelfo/has_many'
require 'efo_nelfo/post_type'
require 'efo_nelfo/post_head_type'

# EfoNelfo v4.0 modules
Dir.glob(File.expand_path('../efo_nelfo/v40/*.rb', __FILE__)).each do |file|
  require file
end

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
