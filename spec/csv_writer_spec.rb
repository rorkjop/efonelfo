# encoding: utf-8
require 'spec_helper'

describe EfoNelfo::V40::BH do
  let(:order) { EfoNelfo::V40::BH.new buyer_id: '123', customer_id: '456' }
  let(:csv)   { order.to_csv }

  describe "to_a" do

    it "returns an array" do
      order.to_a.size.must_equal 1
    end

    it "includes the lines" do
      order.add EfoNelfo::V40::BL.new
      order.add EfoNelfo::V40::BL.new
      order.to_a.size.must_equal 3
    end

  end

  describe "to_csv" do
    before do
      order.add EfoNelfo::V40::BL.new order_number: 'foo', item_name: 'Ware', item_count: 6, splitable: true
      order.add EfoNelfo::V40::BT.new text: 'haha'
    end

    it "includes standard fields" do
      csv.must_match /;EFONELFO;/
      csv.must_match /;4.0;/
      csv.must_match /;123;/
      csv.must_match /;600;/
      csv.must_match /;J;/              # for fixing sublime syntax highlighting: /
    end

    it "can be parsed" do
      o = EfoNelfo.parse(csv)
      o.must_be_instance_of EfoNelfo::V40::BH
      o.lines.first.text.first.must_be_instance_of EfoNelfo::V40::BT
    end

    it "adds order lines" do
      order.add EfoNelfo::V40::BL.new(order_number: 'foo', item_name: 'Ware')
      csv.must_match /Ware/
    end

    it "adds text to order line" do
      csv.must_match /BT;haha/
    end

  end

end
