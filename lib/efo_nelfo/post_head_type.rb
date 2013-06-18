module EfoNelfo
  module PostHeadType

    attr_reader   :lines
    attr_accessor :source

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
