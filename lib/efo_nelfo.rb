# encoding: utf-8
require 'pry-debugger'

require 'efo_nelfo/version'
require 'efo_nelfo/errors'
require 'efo_nelfo/attribute_assignment'
require 'efo_nelfo/property'
require 'efo_nelfo/post_type'
require 'efo_nelfo/v40'

module EfoNelfo

  class << self
    def parse(filename)
      model = initialize_module_from_filename(filename)
      # TODO: detect which reader class to use based on filename/content
      model.parse
    end

    def initialize_module_from_filename(filename)
      case File.basename(filename)[0]
        when "B" then EfoNelfo::V40::Reader::CSV::Order.new filename
      else
        raise UnknownFileType.new "Don't know how to parse '#{filename}'"
      end
    end

    def post_type_for(type, version)
      EfoNelfo::PostType.for type, version
    end

  end


end

