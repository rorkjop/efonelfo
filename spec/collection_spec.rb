require 'spec_helper'

describe EfoNelfo::Collection do
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

  describe "<<" do
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

    describe "passing a hash" do
      let(:hash) {
        { post_type: "BT", version: "2.1", whatever: 'blah' }
      }

      it "accepts a valid hash" do
        array << hash
        array.size.must_equal 1
      end

      it "converts the hash into a post type" do
        array << hash
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

end
