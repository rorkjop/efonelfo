require 'spec_helper'

describe "parsing a RH.csv file" do
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
