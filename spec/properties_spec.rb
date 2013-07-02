# encoding: utf-8
require 'spec_helper'

describe EfoNelfo::Properties do

  class Foo
    include EfoNelfo::Properties
    property :foo, alias: "Føbar", limit: 3, default: 'I am foo'
    property :bar
    property :date, type: :date
    property :number, type: :integer
    property :doable, type: :boolean, default: false
    property :immutable, read_only: true, default: 'NO'
  end

  let(:obj) { Foo.new }

  it "raises an error if trying to add duplicate property" do
    lambda {
      class Bar
        include EfoNelfo::Properties
        property :foo
        property :foo
      end
    }.must_raise EfoNelfo::DuplicateProperty
  end

  it "raises an error if trying to assign an unsupported option" do
    lambda {
      class Bar
        include EfoNelfo::Properties
        property :lame, funny: true
      end
    }.must_raise EfoNelfo::UnknownPropertyOption
  end

  it "adds a getter method for :foo" do
    obj.foo.must_equal 'I am foo'
  end

  it "adds a setter method for :foo" do
    obj.foo = 'Test'
    obj.foo.must_equal 'Test'
  end

  it "adds a question method for boolean types" do
    obj.doable?.must_equal false
    obj.doable = true
    obj.doable?.must_equal true
  end

  it "won't do any encoding conversions" do
    obj.foo = 'Sjøhest'
    obj.foo.encoding.name.must_equal 'UTF-8'
  end

  it "adds an alias getter and setter for foo" do
    obj.foo = 'Test'
    obj.Føbar.must_equal 'Test'
    obj.Føbar = 'Hacked'
    obj.Føbar.must_equal 'Hacked'
    obj.foo.must_equal 'Hacked'
  end

  it "assigns default values" do
    obj.bar.must_be_nil
    obj.foo.must_equal 'I am foo'
  end

  it "can be assigned nil values" do
    obj.number = nil
    obj.number.must_be_nil
  end

  it "readonly attributes cannot be changed" do
    lambda { obj.immutable = 'test' }.must_raise NoMethodError
    obj.immutable.must_equal 'NO'
  end

  describe "property types" do
    describe ":date" do
      it "converts strings to dates" do
        obj.date = "20100504"
        obj.date.must_be_kind_of Date
      end

      it "accepts a Date" do
        obj.date = Date.new 2010, 5, 4
        obj.date.must_be_kind_of Date
      end

    end

    it "handles :integer" do
      obj.number = "2"
      obj.number.must_equal 2
    end

    describe ":boolean" do
      it "returns true when assigning blank string" do
        obj.doable = ''
        obj.doable?.must_equal true
      end

      it "returns true when assigning nil" do
        obj.doable = nil
        obj.doable?.must_equal true
      end

      it "returns true when assigning 'J'" do
        obj.doable = 'J'
        obj.doable?.must_equal true
      end

      it "returns false" do
        obj.doable = false
        obj.doable?.must_equal false

        obj.doable = 'N'
        obj.doable?.must_equal false
      end

    end

  end

  it ".properties contains hash of options" do
    Foo.properties[:foo].must_be_kind_of Hash
  end

  it "#properties contains hash of EfoNelfo::Property objects" do
    Foo.new.properties[:foo].must_be_kind_of EfoNelfo::Property
  end

  it "#has_property? returns true when property exists" do
    obj.has_property?(:foo).must_equal true
    obj.has_property?(:bullshit).must_equal false
  end

  describe "#to_a" do
    it "returns array of all attributes in correct order" do
      obj.date = Date.new 2012, 5, 30
      obj.number = 3
      obj.doable = true
      obj.to_a.must_equal ["I am foo", nil, "20120530", 3, "J", "NO"]
    end
  end

end