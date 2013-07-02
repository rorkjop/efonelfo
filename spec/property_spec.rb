require 'spec_helper'

describe EfoNelfo::Property do
  subject { EfoNelfo::Property.new :foo, options }
  let(:options) { nil }

  describe "initializing with options" do
    let(:options) { { type: :integer, limit: 15, decimals: 4, default: 5, required: true } }

    it { subject.name.must_equal :foo }
    it { subject.default.must_equal 5 }
    it { subject.limit.must_equal 15 }
    it { subject.type.must_equal :integer }
    it { subject.required.must_equal true }
    it { subject.decimals.must_equal 4 }
    it { subject.value.must_equal 5 }

    it "raises an error when assigning to unknown type" do
      lambda {
        EfoNelfo::Property.new :name, type: :get_lost
      }.must_raise EfoNelfo::InvalidPropertyType
    end
  end

  describe "initializing without options" do
    let(:options) { nil }

    it { subject.name.must_equal :foo }
    it { subject.default.must_be_nil }
    it { subject.limit.must_equal 100 }
    it { subject.type.must_equal :string }
    it { subject.required.must_equal false }
    it { subject.decimals.must_be_nil }
    it { subject.value.must_be_nil }
  end

  describe "setter" do
    let(:property) { EfoNelfo::Property.new :name, type: type }

    describe "when type is string" do
      let(:type) { :string }
      it "is just a string" do
        property.value = 'New value'
        property.value.must_equal 'New value'
      end
    end

    describe "when type is boolean" do
      let(:type) { :boolean }

      it "accepts boolean" do
        property.value = true
        property.value.must_equal true

        property.value = false
        property.value.must_equal false
      end

      it "accepts J/N" do
        property.value = 'J'
        property.value.must_equal true

        property.value = 'j'
        property.value.must_equal true

        property.value = 'N'
        property.value.must_equal false
      end
    end

    describe "when type is date" do
      let(:type) { :date }

      it "accepts a Date" do
        property.value = Date.new(2013, 11, 21)
        property.value.must_equal Date.new(2013, 11, 21)
      end

      it "accepts a string" do
        property.value = "20131121"
        property.value.must_equal Date.new(2013, 11, 21)
      end

      it "invalid dates becomes nil" do
        property.value = 'invalid date'
        property.value.must_be_nil
      end

    end

    describe "when type is integer" do
      let(:type) { :integer }

      it "accepts a number" do
        property.value = '2'
        property.value.must_equal 2
      end

      it "floats are rounded" do
        property.value = 200.5
        property.value.must_equal 200
      end

      it "nil becomes nil" do
        property.value = nil
        property.value.must_be_nil
      end

    end

  end

  it "#value= is ignored if the property is readonly" do
    prop = EfoNelfo::Property.new(:name, read_only: true, default: 'untouchable')
    prop.value = 'hey'
    prop.value.must_equal 'untouchable'
  end

  it "#value= converts booleans to proper value" do
    prop = EfoNelfo::Property.new(:name, type: :boolean)
    prop.value = 'J'
    prop.value.must_equal true

    prop.value = 'N'
    prop.value.must_equal false
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

  it "#to_f returns nil when value is NaN" do
    subject.value = nil
    subject.to_f.must_be_nil
  end

  describe "#to_csv" do
    def make_property(value, options={})
      p = EfoNelfo::Property.new :name, options.merge(type: type)
      p.value = value
      p.to_csv
    end

    describe "type is :string" do
      let(:type) { :string }
      it { make_property("A string").must_equal "A string" }
      it { make_property(nil).must_equal nil }
      it { make_property("Sjøhest").encoding.must_equal Encoding::ISO_8859_1 }
    end

    describe "type is :integer" do
      let(:type) { :integer }
      it { make_property(2).must_equal 2 }
      it { make_property(100, type: :integer, decimals: 4).must_equal 100 }
      it { make_property(nil, type: :integer, decimals: 2).must_equal nil }
    end

    describe "type is :boolean" do
      let(:type) { :boolean }
      it { make_property(true).must_equal 'J' }
      it { make_property(false).must_equal 'N' }
      it { make_property(nil).must_equal 'J' }
    end

    describe "type is :date" do
      let(:type) { :date }
      it { make_property(Date.new(2013, 11, 21)).must_equal '20131121' }
      it { make_property("20131121").must_equal "20131121" }
      it { make_property("not a date").must_be_nil }
      it { make_property(nil).must_be_nil }
    end

  end

  it "raises error when initializing with unknown make_property" do
    lambda {
      EfoNelfo::Property.new :name, { foo: 'illegal' }
    }.must_raise EfoNelfo::UnknownPropertyOption
  end

  it ".validate_options! raises error when passing invalid options" do
    lambda {
      EfoNelfo::Property.validate_options! foo: 'bar'
    }.must_raise EfoNelfo::UnknownPropertyOption
  end
end
