require 'spec_helper'

describe EfoNelfo::V40::VL do

  let(:vl) { EfoNelfo::V40::VL.new }

  describe '.parse' do
    let(:csv) { "VL;4;9455483;10-13 AF-2 Armaflex rull/krt.;35 mtr/krt. Cellegummi;2;MTR;METER;3500;10000;20130401;2;;P94551;ARMACELL G;;J;;;B" }
    subject   { EfoNelfo::V40::VL.parse csv }

    it { subject.must_be_instance_of EfoNelfo::V40::VL }

    its(:product_type) { must_equal 4 }
    its(:post_type) { must_equal "VL" }
    its(:product_type) { must_equal 4 }
    its(:product_number) { must_equal "9455483" }
    its(:name) { must_equal "10-13 AF-2 Armaflex rull/krt." }
    its(:description) { must_equal "35 mtr/krt. Cellegummi" }
    its(:unit) { must_equal 2 }
    its(:price_unit) { must_equal "MTR" }
    its(:price_unit_desc) { must_equal "METER" }
    its(:price) { must_equal 3500 }
    its(:amount) { must_equal 10000 }
    its(:price_date) { must_equal Date.new(2013,4,1) }
    its(:status) { must_equal 2 }
    its(:block_number) { must_be_nil }
    its(:discount_group) { must_equal "P94551" }
    its(:fabrication) { must_equal "ARMACELL G" }
    its(:type) { must_be_nil }
  end

  it "#weight returns the weight in gram" do
    vl.info << { field: 'VEKT', value: 250 }
    vl.weight.must_equal 250
  end

  it "#weight returns nil when weight is not present" do
    vl.weight.must_be_nil
  end

  it "#dimension returns nil when dimension isn't present" do
    vl.dimension.must_be_nil
  end

  it "#dimension returns the dimension of the object" do
    vl.info << { field: 'VEKT', value: '10' }
    vl.info << { field: 'DIMENSJON', value: '2x10x20' }
    vl.dimension.must_equal '2x10x20'
  end

  it "#volume returns the volume" do
    vl.info << { field: 'VOLUM', value: '1'}
    vl.info << { field: 'DIMENSJON', value: '2x10x20' }
    vl.volume.must_equal '1'
  end

  it "#volume returns nil when object doesn't have volume" do
    vl.volume.must_be_nil
  end

  it "#gross_price? returns true when price type is 'B'" do
    vl.price_type = 'B'
    vl.gross_price?.must_equal true
    vl.net_price?.must_equal false
  end

  it "#gross_price? returns true when price type is nil" do
    vl.price_type = nil
    vl.gross_price?.must_equal true
    vl.net_price?.must_equal false
  end

  it "#gross_price returns price when price is gross" do
    EfoNelfo::V40::VL.new(price: 2050, price_type: 'B').gross_price.must_equal 20.5
  end

  it "#net_price returns nil when price is gross" do
    EfoNelfo::V40::VL.new(price: 2050, price_type: 'B').net_price.must_be_nil
  end

  it "#net_price returns price when price is net" do
    EfoNelfo::V40::VL.new(price: 2050, price_type: 'N').net_price.must_equal 20.5
  end

  it "#gross_price returns nil when price is net" do
    EfoNelfo::V40::VL.new(price: 2050, price_type: 'N').gross_price.must_be_nil
  end

  it "#net_price? returns true when price type is 'N'" do
    vl.price_type = 'N'
    vl.net_price?.must_equal true
    vl.gross_price?.must_equal false
  end

  it "#urls returns list of vx lines containing a url" do
    vl.info << { field: 'FOO', value: 'http://localhost/one?two'}
    vl.info << { field: 'BAR', value: 'http://foo.example.com/one/two/three'}
    vl.info << { field: 'FOO', value: 'http-not-a-url' }
    vl.urls.must_equal [ 'http://localhost/one?two', 'http://foo.example.com/one/two/three']
  end

  describe "#images" do
    it "returns nil when there are no images available" do
      vl.images.must_be_empty
    end

    it "returns array of urls when images are present" do
      vl.info << { field: 'BILDE', value: 'http://foo/bar.png' }
      vl.info << { field: 'BILDE', value: 'http://foo/bar.gif' }
      vl.info << { field: 'VEKT', value: '2kg' }
      vl.images.must_equal ['http://foo/bar.png', 'http://foo/bar.gif']
    end

  end

end
