require 'spec_helper'

describe "parsing a BH.csv file" do

  it "uses the correct version" do
    lambda { EfoNelfo.load(csv('B123.V3.csv')) }.must_raise EfoNelfo::UnsupportedPostType
  end

  it "parses the file and returns an Order" do
    EfoNelfo.load(csv('B650517.032.csv')).must_be_instance_of EfoNelfo::V40::BH
  end

  it "the order contains order information" do
    order = EfoNelfo.load(csv('B650517.032.csv'))
    order.post_type.must_equal 'BH'
    order.format.must_equal 'EFONELFO'
    order.version.must_equal '4.0'
  end

  it "the order contains orderlines" do
    order = EfoNelfo.load(csv('B650517.032.csv'))

    line = order.lines.first
    line.must_be_instance_of EfoNelfo::V40::BL

    line.post_type.must_equal 'BL'

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
    order.lines.first.text.first.to_s.must_equal "Her er litt fritekst"
  end

end
