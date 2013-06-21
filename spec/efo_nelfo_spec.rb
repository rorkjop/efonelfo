# encoding: utf-8
require 'spec_helper'

# helper method that returns full path to csv files
def csv(filename)
  File.expand_path("../samples/#{filename}", __FILE__)
end

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

    describe "passing a Product file" do
      let(:nelfo) { EfoNelfo.load(csv('varefil_eksempel.csv')) }

      it { nelfo.must_be_instance_of EfoNelfo::V40::VH }

      it "loads the order" do
        nelfo.format.must_equal "EFONELFO"
        nelfo.version.must_equal "4.0"
        nelfo.post_type.must_equal "VH"
        nelfo.SelgersId.must_equal "NO1234567879MVA"
        nelfo.KjøpersId.must_be_nil
        nelfo.KundeNr.must_be_nil
        nelfo.from_date.must_equal Date.new(2004, 1, 22)
        nelfo.to_date.must_be_nil
        nelfo.currency.must_equal "NOK"
        nelfo.contract_id.must_be_nil
        nelfo.seller_name.must_equal "ONNINEN A/S"
        nelfo.seller_address1.must_equal "P.B. 70"
        nelfo.seller_address2.must_be_nil
        nelfo.seller_zip.must_equal "1483"
        nelfo.seller_office.must_equal "SKYTTA"
        nelfo.seller_country.must_equal "NO"
      end

      it "adds product lines" do
        nelfo.lines.count.must_equal 3

        line = nelfo.lines.first
        line.product_type.must_equal 1
        line.product_number.must_equal "1006100"
        line.name.must_equal "MATTE 3MM 100W/M2  100W"
        line.description.must_equal "1,0 m2 0,5 x 2,0 m"
        line.unit.must_equal 1
        line.price_unit.must_equal "EA"
        line.price_unit_desc.must_equal "STYKK"
        line.price.must_equal 55300
        line.amount.must_equal 10000
        line.price_date.must_equal Date.new(2011,9,1)
        line.status.must_equal 1
        line.block_number.must_be_nil
        line.discount_group.must_equal "1004"
        line.fabrication.must_be_nil
        line.type.must_be_nil
        line.stocked.must_equal true
        line.stocked?.must_equal true
        line.sales_package.must_equal 10000
      end

      it "adds additional information to the product" do
        line = nelfo.lines.first
        line.info.first.value.must_equal "http://www.elektroskandia.no/image/products/1221102.gif"
      end
    end

    describe "passing a discount file" do
      let(:nelfo) { EfoNelfo.load csv('rabatt.csv') }
      it { nelfo.must_be_instance_of EfoNelfo::V40::RH }
      # RH;EFONELFO;4.0;NO910478656MVA;NO000000000MVA;0;0;20130404;20140404;NOK;H;Alsell Norge AS;Vestre Svanholmen 4;;4313;SANDNES;NO
      it "assigns attributes" do
        nelfo.seller_id.must_equal "NO910478656MVA"
        nelfo.buyer_id.must_equal "NO000000000MVA"
      end

      it "assigns lines" do
        nelfo.lines.size.must_equal 4
        line = nelfo.lines.last
        line.product_type.must_equal 5
        line.product_number.must_equal "P10501"
        line.AvtaltPris.must_be_nil
      end
    end

    describe "passing a Order file" do

      it "uses the correct version" do
        lambda { EfoNelfo.load(csv('B123.v3.csv')) }.must_raise EfoNelfo::UnsupportedPostType
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

      it "stores the contents file in the Order object" do
        filename = csv('B650517.032.csv')
        order = EfoNelfo.load(filename)
        order.source.must_equal File.read(filename)
      end
    end

    # Loads all files in the samples directory
    %w(B028579.594.csv B028579.596.csv B650517.031.csv B028579.595.csv B028579.597.csv B650517.030.csv B650517.032.csv).each do |file|
      it "can load #{file}" do
        EfoNelfo.load(csv(file)).must_be_instance_of EfoNelfo::V40::BH
      end
    end

  end

end
