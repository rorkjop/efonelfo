# encoding: utf-8
require 'pry-debugger'

# Common stuff
require 'efo_nelfo/version'
require 'efo_nelfo/errors'
require 'efo_nelfo/attribute_assignment'
require 'efo_nelfo/property'
require 'efo_nelfo/post_type'

# v4.0
require 'efo_nelfo/v40/order/order'
require 'efo_nelfo/v40/order/line'
require 'efo_nelfo/v40/order/text'

# Reader modules (import)
require 'efo_nelfo/reader/csv'

module EfoNelfo

  class << self

    def parse(filename)
      model = initialize_import_module_from_filename(filename)
      model.parse
    end

    private

    # This is supposed to determine whether to use CSV or XML.
    # Currently, only CSV is supported.
    def initialize_import_module_from_filename(filename)
      Reader::CSV.new filename
    end

  end


end

