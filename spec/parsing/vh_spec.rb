require 'spec_helper'


describe "parsing a VH.csv file" do
  let(:nelfo) { EfoNelfo.load(csv('varefil_eksempel.csv')) }

  it { nelfo.must_be_instance_of EfoNelfo::V40::VH }

  it "loads the order" do
    nelfo.format.must_equal "EFONELFO"
    nelfo.version.must_equal "4.0"
    nelfo.post_type.must_equal "VH"
    nelfo.SelgersId.must_equal "NO123456787MVA"
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

  it "adds product alternatives" do
    nelfo.lines.first.alternatives.first.must_be_instance_of EfoNelfo::V40::VA
    nelfo.lines.first.alternatives.first.product_type.must_equal 1
    nelfo.lines.first.alternatives.last.replacement?.must_equal true
  end
end
