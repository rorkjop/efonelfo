require 'spec_helper'

describe EfoNelfo::V40::VA do

  describe "has aliases for various types" do

    it { EfoNelfo::V40::VA.new(type: 'A').alternative?.must_equal true }
    it { EfoNelfo::V40::VA.new(type: 'E').replacement?.must_equal true }
    it { EfoNelfo::V40::VA.new(type: 'V').alternative_id?.must_equal true }
    it { EfoNelfo::V40::VA.new(type: 'P').package_size?.must_equal true }

  end

  it "#nrf_id returns true if product_type is 4" do
    EfoNelfo::V40::VA.new(product_type: 4, product_number: '1234').nrf_id.must_equal '1234'
  end

end
