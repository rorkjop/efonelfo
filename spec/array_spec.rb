require 'spec_helper'

describe EfoNelfo::Array do
  let(:owner) { MiniTest::Mock.new }
  let(:type)  { MiniTest::Mock.new }

  let(:array) { EfoNelfo::Array.new "The owner", "BT" }

  it "accepts owner and post_type arguments" do
    array.owner.must_equal "The owner"
    array.post_type.must_equal "BT"
  end

  describe "<<" do
    Foo = Class.new(EfoNelfo::PostType)

    let(:obj) { Foo.new }

    it "accepts a valid hash" do
      obj = { post_type: "BT", whatever: 'blah' }
      array << obj
      array.size.must_equal 1
    end

    it "accepts a valid posttype" do
      def obj.post_type; 'BT'; end
      array << obj
      array.must_include obj
    end

    it "raises an error if the object being added is of wrong type" do
      def obj.post_type; 'BH'; end
      lambda { array << obj }.must_raise(EfoNelfo::InvalidPostType)
    end
  end

end
