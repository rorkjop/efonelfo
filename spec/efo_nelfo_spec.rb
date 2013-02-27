# encoding: utf-8
require 'spec_helper'

# helper method that returns full path to csv files
def csv(filename)
  File.expand_path("../samples/#{filename}", __FILE__)
end

describe EfoNelfo do

  describe "properties" do
    it "is accessible as alias" do
      order = EfoNelfo::V40::Order.new
      order.buyer_id = "123"
      order.KjøpersId.must_equal "123"
    end

    it "can update the variable using the alias" do
      order = EfoNelfo::V40::Order.new
      order.KjøpersId = "foo"
      order.buyer_id.must_equal "foo"
    end

    it "has custom setters" do
      EfoNelfo::V40::Order.new(delivery_date: "20110402").delivery_date.must_be_kind_of Date
    end

  end

  describe "assign via hash" do
    let(:json) {
      { customer_id: "123",
        order_number: "abc-123-efg",
        seller_warehouse: "Somewhere",
        label: "Some label",
        lines: [
          { item_type: 1, order_number: "12345", item_name: "Foo", price_unit: "NOK" },
          { item_type: 1, order_number: "12345", item_name: "Bar", price_unit: "SEK", text: "This is freetext"},
        ]
      }
    }
    let(:order) { EfoNelfo::V40::Order.new json }

    it "creates an order" do
      order.must_be_instance_of EfoNelfo::V40::Order
    end

    it "assigns attributes" do
      order.order_number.must_equal "abc-123-efg"
      order.seller_warehouse.must_equal "Somewhere"
    end

    it "assigns order lines" do
      order.lines.size.must_equal 2
      order.lines[0].index.must_equal 1
      order.lines[1].index.must_equal 2
      order.lines[1].item_name.must_equal "Bar"
    end

    it "adds text to order lines" do
      order.lines.first.text.must_be_nil
      order.lines[1].text.must_be_instance_of EfoNelfo::V40::Order::Text
      order.lines[1].text.to_s.must_equal "This is freetext"
    end

  end

  describe ".parse" do

    it "parses CSV and does the same as .load" do
      filename = csv('B650517.032.csv')
      parsed = EfoNelfo.parse File.read(filename)
      loaded = EfoNelfo.load filename
      parsed.source.must_equal loaded.source
    end

  end

  describe ".load" do

    describe "when passing in invalid file" do
      it "raises an exception" do
        lambda { EfoNelfo.load 'foo' }.must_raise Errno::ENOENT
      end
    end

    describe "passing a Order file" do

      it "uses the correct version" do
        lambda { EfoNelfo.load(csv('B123.v3.csv')) }.must_raise EfoNelfo::UnsupportedPostType
      end

      it "parses the file and returns an Order" do
        EfoNelfo.load(csv('B650517.032.csv')).must_be_instance_of EfoNelfo::V40::Order
      end

      it "the order contains order information" do
        order = EfoNelfo.load(csv('B650517.032.csv'))
        order.post_type.must_equal 'BH'
        order.post_type_human.must_equal 'Bestilling Hodepost'
        order.format.must_equal 'EFONELFO'
        order.version.must_equal '4.0'
      end

      it "the order contains orderlines" do
        order = EfoNelfo.load(csv('B650517.032.csv'))

        line = order.lines.first
        line.must_be_instance_of EfoNelfo::V40::Order::Line

        line.post_type.must_equal 'BL'
        line.post_type_human.must_equal 'Bestilling vareLinjepost'

        line.index.must_equal 1
        line.order_number.must_equal '1465'
        line.item_count.must_equal 200
        line.price_unit.must_equal "EA"
        line.buyer_item_number.must_be_nil
        line.delivery_date.must_equal Date.new(2010, 6, 1)
        line.buyer_ref.must_be_nil
        line.splitable.must_equal true
        line.replacable.must_equal true

        line.item_type.must_equal 1
        line.item_number.must_equal '8000502'
        line.item_name.must_equal '200L OSO STD BEREDER SUPER S'
        line.item_description.must_be_nil
      end

      it "adds text to orderline" do
        order = EfoNelfo.load(csv('B650517.032.csv'))
        line  = order.lines.first
        line.text.to_s.must_equal "Her er litt fritekst"
      end

      it "stores the contents file in the Order object" do
        filename = csv('B650517.032.csv')
        order = EfoNelfo.load(filename)
        order.source.must_equal File.read(filename)
      end
    end

    # Loads all files in the samples directory
    %w(B028579.594.csv B028579.596.csv B650517.031.csv B028579.595.csv B028579.597.csv B650517.030.csv B650517.032.csv).each do |file|
      it "can load #{file}" do
        EfoNelfo.load(csv(file)).must_be_instance_of EfoNelfo::V40::Order
      end
    end

  end

end
