require 'spec_helper'

describe EfoNelfo::Collection do
  module EfoNelfo
    module V21
      class MyType < EfoNelfo::PostType
        property :whatever
        property :version
      end

      class BT < EfoNelfo::PostType
        property :post_type
        property :whatever
        property :version
      end
    end
  end

  Owner = Class.new do
    def self.version_from_class
      '21'
    end
  end

  let(:owner) { Owner.new }
  let(:array) { EfoNelfo::Collection.new owner, "BT" }

  it "accepts owner and post_type arguments" do
    array.owner.must_equal owner
    array.post_type.must_equal "BT"
  end

  it ".delete removes the element at given position" do
    array << { post_type: "BT", whatever: 'blah' }
    array.delete(0)
    array.size.must_equal 0
  end

  describe "<<" do

    describe "passing a hash" do
      let(:a_hash) {
        { post_type: "BT", version: "2.1", whatever: 'blah' }
      }

      it "accepts a valid hash" do
        array << a_hash
        array.size.must_equal 1
      end

      it "converts the hash into a post type" do
        array << a_hash
        array[0].must_be_instance_of EfoNelfo::V21::BT
        array[0].whatever.must_equal 'blah'
      end

    end

    describe "passing a PostType object" do
      let(:obj) { EfoNelfo::V21::MyType.new }

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

  describe "#find_by" do
    before do
      array << { post_type: 'BT', whatever: 'foo' }
      array << { post_type: 'BT', whatever: 'bar' }
    end

    it "returns the matching rows" do
      array.find_by(whatever: 'foo').must_be_instance_of Array
      array.find_by(whatever: 'foo').first.must_be_instance_of EfoNelfo::V21::BT
    end

    it "returns empty array when no rows could be found" do
      array.find_by(whatever: 'barr').must_be_empty
    end

    it "returns empty array when trying to search for a key that doesn't exist" do
      array.find_by(blue_dragon_breath: 'wtf').must_be_empty
    end

  end

end
