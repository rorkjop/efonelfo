# encoding: utf-8
require 'pry-debugger'

require 'efo_nelfo/version'
require 'efo_nelfo/errors'
require 'efo_nelfo/attribute_assignment'
require 'efo_nelfo/property'
require 'efo_nelfo/post_type'
require 'efo_nelfo/v40'

# Reader modules
require 'efo_nelfo/reader/csv/base'
require 'efo_nelfo/reader/csv/v40/order'

module EfoNelfo

  class << self

    def parse(filename)
      # TODO: detect which reader class to use based on filename/content
      model = initialize_import_module_from_filename(filename)
      model.parse
    end

    # private

    def initialize_import_module_from_filename(filename)
      extension = File.extname(filename).gsub(/\./, '')
      klass = case extension
      when 'xml' then raise UnsupportedFileFormat.new("XML is not yet supported")
      else
        Reader::CSV::Base.find_module_for(filename)
      end

      raise UnknownFileType if klass.nil?
      klass.new filename

      # Hardcoded for now.
      # TODO:
      # 1. Detect CSV/XML based on extension (FILETYPE)
      # 2. Detect module based on first letter of filename (MODULE)
      # 3. Detect version. For CSV this can be determined from the first line in the file (VERSION)
      # 4. Return an instance based on the above or raise an UnknownXXX error
      #    => EfoNelfo::VERSION::Reader::FILETYPE::MODULE.new filename
      # EfoNelfo::Reader::FILETYPE::VERSION::MODULE
      # case File.basename(filename)[0]
      #   when "B" then EfoNelfo::Reader::CSV::V40::Order.new filename
      # else
      #   raise UnknownFileType.new "Don't know how to parse '#{filename}'"
      # end
    end

    def post_type_for(type, version)
      EfoNelfo::PostType.for type, version
    end

  end


end

