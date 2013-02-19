# encoding: utf-8
require 'pry-debugger'

require 'efo_nelfo/version'
require 'efo_nelfo/errors'
require 'efo_nelfo/attribute_assignment'
require 'efo_nelfo/property'
require 'efo_nelfo/post_type'
require 'efo_nelfo/v40'

# Reader modules
require 'efo_nelfo/reader/csv'

module EfoNelfo

  class << self

    def parse(filename)
      # TODO: detect which reader class to use based on filename/content
      model = initialize_import_module_from_filename(filename)
      model.parse
    end

    # private

    # This is supposed to determine whether to use CSV or XML parser.
    # Currently, only CSV is supported.
    def initialize_import_module_from_filename(filename)
      Reader::CSV.new filename
    end

    def post_type_for(type, version)
      EfoNelfo::PostType.for type, version
    end

  end


end

