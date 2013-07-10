# encoding: utf-8
require 'spec_helper'

describe EfoNelfo do

  describe "properties" do
    it "is accessible as alias" do
      order = EfoNelfo::V40::BH.new
      order.buyer_id = "123"
      order.KjøpersId.must_equal "123"
    end

    it "can update the variable using the alias" do
      order = EfoNelfo::V40::BH.new
      order.KjøpersId = "foo"
      order.buyer_id.must_equal "foo"
    end

    it "has custom setters" do
      EfoNelfo::V40::BH.new(delivery_date: "20110402").delivery_date.must_be_kind_of Date
    end

  end

  describe "assign via hash" do
    let(:json) {
      { customer_id: "123",
        order_number: "abc-123-efg",
        seller_warehouse: "Somewhere",
        label: "Some label",
        lines: [
          { post_type: 'BL', item_type: 1, order_number: "12345", item_name: "Foo", price_unit: "NOK" },
          { post_type: 'BL', item_type: 1, order_number: "12345", item_name: "Bar", price_unit: "SEK", text: [
            { post_type: 'BT', text: "some dummy lorem ipsum text" }
          ] }
        ]
      }
    }
    let(:order) { EfoNelfo::V40::BH.new json }

    it "creates an order" do
      order.must_be_instance_of EfoNelfo::V40::BH
    end

    it "assigns attributes" do
      order.order_number.must_equal "abc-123-efg"
      order.seller_warehouse.must_equal "Somewhere"
    end

    it "assigns order lines" do
      order.lines.size.must_equal 2
      order.lines.first.must_be_instance_of EfoNelfo::V40::BL
      order.lines[0].item_name.must_equal "Foo"
      order.lines[1].item_name.must_equal "Bar"
    end

    it "adds index to the line items" do
      order.lines[0].index.must_equal 1
      order.lines[1].index.must_equal 2
    end

    it "adds text to order lines" do
      order.lines.first.text.must_be_empty
      order.lines[1].text.first.must_be_instance_of EfoNelfo::V40::BT
      order.lines[1].text.first.to_s.must_equal "some dummy lorem ipsum text"
    end

  end

  describe ".load" do
    describe "when passing in invalid file" do
      it "raises an exception" do
        lambda { EfoNelfo.load 'foo' }.must_raise Errno::ENOENT
      end
    end

    # Loads all files in the samples directory
    %w(B028579.594.csv B028579.596.csv B650517.031.csv B028579.595.csv B028579.597.csv B650517.030.csv B650517.032.csv).each do |file|
      it "can load #{file}" do
        EfoNelfo.load(csv(file)).must_be_instance_of EfoNelfo::V40::BH
      end
    end
  end


  describe ".parse" do
    it "uses the CSV reader to parse the input" do
      input  = File.read csv('B650517.032.csv')
      result = EfoNelfo.parse(input)
      result.must_be_instance_of EfoNelfo::V40::BH
    end
  end

end
