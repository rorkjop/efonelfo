require 'spec_helper'

describe EfoNelfo::Property do

  class Foo
    include EfoNelfo::Property
    property :foo, alias: "Foobar", limit: 3, default: 'I am foo'
    property :bar
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
