require 'spec_helper'

describe EfoNelfo::V40::VL do

  let(:vl) { EfoNelfo::V40::VL.new }

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
