require 'spec_helper'

describe EfoNelfo::Property do
  subject { EfoNelfo::Property.new :foo, options }
  let(:options) { nil }

  describe "initializing with options" do
    let(:options) { { type: :integer, decimals: 4, default: 5, required: true } }

    it { subject.name.must_equal :foo }
    it { subject.default.must_equal 5 }
    it { subject.type.must_equal :integer }
    it { subject.required.must_equal true }
    it { subject.decimals.must_equal 4 }
    it { subject.value.must_equal 5 }
  end

  describe "initializing without options" do
    let(:options) { nil }

    it { subject.name.must_equal :foo }
    it { subject.default.must_be_nil }
    it { subject.type.must_equal :string }
    it { subject.required.must_equal false }
    it { subject.decimals.must_be_nil }
    it { subject.value.must_be_nil }
  end

  it "has a setter for the value" do
    subject.value = 'foo'
    subject.value.must_equal 'foo'
  end

  it "#to_f returns the value with decimals" do
    prop = EfoNelfo::Property.new(:name, decimals: 4)
    prop.value = 1000
    prop.to_f.must_equal 0.1
  end

  it "#to_f doesn't fail when decimals is nil" do
    subject.value = "100"
    subject.to_f.must_equal 100.0
  end

  it "raises error when initializing with unknown property" do
    lambda {
      EfoNelfo::Property.new :name, { foo: 'illegal' }
    }.must_raise EfoNelfo::UnknownPropertyOption
  end

end
