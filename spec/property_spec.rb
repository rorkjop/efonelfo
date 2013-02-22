# encoding: utf-8
require 'spec_helper'

describe EfoNelfo::Property do

  class Foo
    include EfoNelfo::Property
    property :foo, alias: "Føbar", limit: 3, default: 'I am foo'
    property :bar
    property :date, type: :date
    property :number, type: :integer
    property :doable, type: :boolean, default: false
  end

  let(:obj) { Foo.new }

  it "raises an error if trying to add duplicate property" do
    lambda {
      class Bar
        include EfoNelfo::Property
        property :foo
        property :foo
      end
    }.must_raise EfoNelfo::DuplicateProperty
  end

  it "adds a getter and setter for foo" do
    obj.foo = 'Test'
    obj.foo.must_equal 'Test'
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

  describe ".properties" do
    let(:props) { Foo.properties }

    it "includes the properties" do
      props[:foo].must_be_kind_of Hash
    end

    it "includes the property options" do
      props[:foo][:limit].must_equal 3
    end
  end

end
