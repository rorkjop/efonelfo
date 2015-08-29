require 'spec_helper'

describe "parsing a CH.csv file" do
  it "uses the correct version" do
    lambda { EfoNelfo.load(csv('C4.V3.csv')) }.must_raise EfoNelfo::UnsupportedPostType
  end

  it "parses the file and returns an OrderConfirmation" do
    order = EfoNelfo.load(csv('C450517.032.csv'))
    order.must_be_instance_of EfoNelfo::V40::CH
    order.post_type.must_equal "CH"
    order.format.must_equal "EFONELFO"
    order.version.must_equal "4.0"

    order.BekreftelsesNr.must_equal "52104503D0001"
    order.SOrdNr.must_equal "52104503D"
    order.BestNr.must_equal "BE0000 23"
    order.KundeNr.must_equal "2110310"
    order.KjøpersRef.must_equal "Knut"
    order.SelgersRef.must_equal "Ole N."
    order.Merket.must_equal "BE2/2"
    order.TransportMåte.must_equal "ROAD"
    order.Melding.must_equal "Ring Jacob 92413009"
    order.LevDato.to_s.must_equal "2005-04-25"
  end

  it "the order confirmation contains orderlines" do
    order = EfoNelfo.load(csv('C450517.032.csv'))

    line = order.lines[1]
    line.must_be_instance_of EfoNelfo::V40::CL
    line.post_type.must_equal "CL"
    line.index_seller.must_equal 30
    line.index_buyer.must_equal 3
    line.VareNr.must_equal "1261190"
    line.VaBetg.must_equal "INNSTIKK-KLEMME 2X2,5MM2 WAGO"
    line.Ant.must_equal 3000
    line.Lev.must_equal 2000
    line.Rest.must_equal 1000
    line.PrisEnhet.must_equal "EA"
    line.RLevDato.to_s.must_equal "2005-05-02"
    line.EnhetsPris.must_equal 8000
  end
end
