require 'spec_helper'

describe EfoNelfo::V40::VL do

  let(:vl) { EfoNelfo::V40::VL.new }

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