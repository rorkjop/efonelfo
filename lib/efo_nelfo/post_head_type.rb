module EfoNelfo
  module PostHeadType
    attr_accessor :source

    def self.included(base)
      base.send :property, :post_type,  alias: :PostType,      limit: 2, default: base.post_type
      base.send :property, :format,     alias: :Format,        limit: 8, default: 'EFONELFO'
      base.send :property, :version,    alias: :Versjon,       limit: 3, default: base.version
    end

    def add(post_type)
      if has_association? post_type
        find_association(post_type) << post_type
      else
        if lines.any?
          lines.last.find_association(post_type) << post_type
        end
      end
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
