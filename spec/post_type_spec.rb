require 'spec_helper'

describe EfoNelfo::PostType do

  module EfoNelfo
    module V21
      class AB < EfoNelfo::PostType
        property :post_type, default: 'AB'
        property :version, default: '21'
        property :seller_id
        has_many :lines, :post_type => "XY"
      end

      class XY < EfoNelfo::PostType
        property :post_type, default: 'XY'
        property :order_number
      end
    end
  end

  describe "versioning" do

    it ".version_from_class returns the version" do
      EfoNelfo::V21::AB.version_from_class.must_equal "21"
    end

    it ".version returns the version as a number" do
      EfoNelfo::V21::AB.version.must_equal "2.1"
    end

    it ".version_to_namespace converts version to module name" do
      EfoNelfo::V21::AB.version_to_namespace("2.1").must_equal "21"
    end

  end

  describe "to_csv" do
    it "converts the posttype to csv" do
      pt = EfoNelfo::V21::AB.new seller_id: '123'
      pt.lines << EfoNelfo::V21::XY.new(order_number: '41')
      pt.to_csv.must_match /AB;21;123.+XY;41/m
    end
  end

  describe ".from" do
    let(:a_hash) {
      {
        post_type: "AB",
        version: "2.1",
        seller_id: "123",
        lines: [
          { post_type: "XY", order_number: "666-2" }
        ]
      }
    }

    let(:pt) { EfoNelfo::PostType.from a_hash }

    it "converts the hash into a valid posttype" do
      pt.must_be_instance_of EfoNelfo::V21::AB
      pt.seller_id.must_equal "123"
    end

    # it "adds lines" do
    #   pt.lines.size.must_equal 1
    #   pt.lines.first.order_number.must_equal "666-2"
    # end

  end

end
