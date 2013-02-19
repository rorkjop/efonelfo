# encoding: utf-8
require 'efo_nelfo/order/v40/head'
require 'efo_nelfo/order/v40/line'
require 'efo_nelfo/order/v40/item'

module EfoNelfo

  class Order
    attr_accessor :heads

    def initialize
      @heads = []
    end

    def parse(csv)
      csv.each do |row|
        case row[0]
        when 'BH'
          @heads << V40::Head.new(row)
        when 'BL'
          @heads.last.lines << V40::Line.new(row)
        end
      end
    end

    def to_csv(options={})
      # not yet implemented
    end

    def to_json(options={})
      # not yet implemented
    end

  end

end
