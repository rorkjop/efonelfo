module EfoNelfo
  module PostHeadType
    attr_reader   :lines
    attr_accessor :source

    def self.included(base)
      base.send :property, :post_type,  alias: :PostType,      limit: 2, default: base.post_type
      base.send :property, :format,     alias: :Format,        limit: 8, default: 'EFONELFO'
      base.send :property, :version,    alias: :Versjon,       limit: 3, default: base.version
    end

    def initialize(*args)
      @lines = EfoNelfo::Array.new
      super
    end

    def lines=(values)
      @lines = EfoNelfo::Array.new
      values.each do |item|
        add item
      end
    end

    def add(post_type)
      lines << post_type
    end

    def to_a
      [ super ] + lines.to_a
    end

    def to_csv
      CSV.generate EfoNelfo::Reader::CSV::CSV_OPTIONS do |csv|
        to_a.each do |row|
          csv << row unless row.empty?
        end
      end
    end

  end
end
