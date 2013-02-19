# encoding: utf-8
# $: << File.expand_path('../../lib', __FILE__)
require 'efo_nelfo'

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry-debugger'

def csv(filename)
  File.expand_path("../samples/#{filename}", __FILE__)
end

describe EfoNelfo do

  describe ".post_type_for" do
    it "finds module based on posttype and format" do
      EfoNelfo.post_type_for("BH", "4.0").must_equal EfoNelfo::V40::Order::Head
      EfoNelfo.post_type_for("BL", "4.0").must_equal EfoNelfo::V40::Order::Line
    end
  end

  describe "properties" do
    it "is accessible as alias" do
      head = EfoNelfo::V40::Order::Head.new
      head.buyer_id = "123"
      head.KjøpersId.must_equal "123"
    end

    it "can update the variable using the alias" do
      head = EfoNelfo::V40::Order::Head.new
      head.KjøpersId = "foo"
      head.buyer_id.must_equal "foo"
    end

    it "should be valid" do
      EfoNelfo::V40::Order::Head.new.valid?.must_equal true
    end

  end

  describe ".parse" do

    describe "when passing in invalid file" do
      it "raises an exception" do
        lambda { EfoNelfo.parse 'foo' }.must_raise RuntimeError
      end
    end

    describe "passing a Order file" do
      it ".parse parses the file and returns a EfoNelfo::Order object" do
        efo = EfoNelfo.parse csv('B650517.032.csv')
        efo.must_be_instance_of EfoNelfo::V40::Order
      end

      it "adds a Order::Head" do
        efo = EfoNelfo.parse csv('B650517.032.csv')
        efo.heads[0].must_be_instance_of EfoNelfo::V40::Order::Head
      end

      it "the head contains order information" do
        head = EfoNelfo.parse(csv('B650517.032.csv')).heads.first
        head.post_type.must_equal 'BH'
        head.post_type_human.must_equal 'Bestilling Hodepost'
        head.format.must_equal 'EFONELFO'
        head.version.must_equal '4.0'
      end

      it "the head contains orderlines" do
        head = EfoNelfo.parse(csv('B650517.032.csv')).heads.first

        line = head.lines.first
        line.must_be_instance_of EfoNelfo::V40::Order::Line

        line.post_type.must_equal 'BL'
        line.post_type_human.must_equal 'Bestilling vareLinjepost'

        line.line_no.must_equal '1'
        line.order_ref.must_equal '1465'
        line.count.must_equal 2.0
        line.price_unit.must_equal "EA"
        line.buyer_item_no.must_be_nil
        line.delivery_date.must_equal Date.new(2010, 6, 1)
        line.buyer_ref.must_be_nil
        line.splitable.must_equal true
        line.replacable.must_equal true

        line.item.type.must_equal '1'
        line.item.number.must_equal '8000502'
        line.item.name.must_equal '200L OSO STD BEREDER SUPER S'
        line.item.description.must_be_nil
      end

    end

    # Parse all files in the samples directory
    Dir.glob("test/samples/*.csv").each do |file|
      it "can parse #{file}" do
        EfoNelfo.parse(file).must_be_instance_of EfoNelfo::V40::Order
      end
    end

  end

end
