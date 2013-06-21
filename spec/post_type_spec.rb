require 'spec_helper'

describe EfoNelfo::PostType do

  module EfoNelfo
    module V21
      class Foo < EfoNelfo::PostType
        property :post_type
        property :version
        property :seller_id
        has_many :lines, :post_type => "Bar"
      end

      class Bar < EfoNelfo::PostType
        property :post_type
        property :order_number
      end
    end
  end

  describe "versioning" do

    it ".version_from_class returns the version" do
      EfoNelfo::V21::Foo.version_from_class.must_equal "21"
    end

    it ".version returns the version as a number" do
      EfoNelfo::V21::Foo.version.must_equal "2.1"
    end

    it ".version_to_namespace converts version to module name" do
      EfoNelfo::V21::Foo.version_to_namespace("2.1").must_equal "21"
    end

  end

  describe ".from" do
    let(:hash) {
      {
        post_type: "Foo",
        version: "2.1",
        seller_id: "123",
        lines: [
          { post_type: "Bar", order_number: "666-2" }
        ]
      }
    }

    let(:pt) { EfoNelfo::PostType.from hash }

    it "converts the hash into a valid posttype" do
      pt.must_be_instance_of EfoNelfo::V21::Foo
      pt.seller_id.must_equal "123"
    end

    # it "adds lines" do
    #   pt.lines.size.must_equal 1
    #   pt.lines.first.order_number.must_equal "666-2"
    # end

  end

end
