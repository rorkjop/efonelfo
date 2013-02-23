# encoding: utf-8
require 'spec_helper'

describe EfoNelfo::V40::Order do
  let(:order) { EfoNelfo::V40::Order.new buyer_id: '123', customer_id: '456' }
  let(:csv)   { order.to_csv }

  describe "to_csv" do
    before do
      order.add EfoNelfo::V40::Order::Line.new(order_number: 'foo', item_name: 'Ware')
      order.add EfoNelfo::V40::Order::Text.new text: 'haha'
    end

    it "includes standard fields" do
      csv.must_match /;EFONELFO;/
      csv.must_match /;4.0;/
      csv.must_match /;123;/
    end

    it "can be parsed" do
      o = EfoNelfo.parse(csv)
      o.must_be_instance_of EfoNelfo::V40::Order
      o.lines.first.text.must_be_instance_of EfoNelfo::V40::Order::Text
    end

    it "adds order lines" do
      order.add EfoNelfo::V40::Order::Line.new(order_number: 'foo', item_name: 'Ware')
      csv.must_match /Ware/
    end

    it "adds text to order line" do
      csv.must_match /haha/
    end

  end

end
