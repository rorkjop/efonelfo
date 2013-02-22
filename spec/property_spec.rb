require 'spec_helper'

describe EfoNelfo::Property do

  class Foo
    include EfoNelfo::Property
    property :foo, alias: "Foobar", limit: 3, default: 'I am foo'
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
    obj.Foobar.must_equal 'Test'
    obj.Foobar = 'Hacked'
    obj.Foobar.must_equal 'Hacked'
    obj.foo.must_equal 'Hacked'
  end

  it "assigns default values" do
    obj.bar.must_be_nil
    obj.foo.must_equal 'I am foo'
  end

  describe "property types" do
    it "handles :date" do
      obj.date = "20100504"
      obj.date.must_be_kind_of Date
    end

    it "handles :integer" do
      obj.number = "2"
      obj.number.must_equal 2
    end

    it "handles :boolean" do
      obj.doable?.must_equal false
      obj.doable = 'J'
      obj.doable.must_equal true
      obj.doable = false
      obj.doable.must_equal false
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
