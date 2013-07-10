require 'forwardable'

module EfoNelfo

  class Collection
    include Enumerable
    extend Forwardable

    attr_reader :owner, :post_type

    def_delegators :@list, :[], :each, :last, :size, :empty?

    def initialize(owner, post_type)
      @owner     = owner
      @post_type = post_type
      @list      = []
    end

    def <<(obj)
      obj = post_type_class.new(obj) if obj.is_a? Hash
      raise EfoNelfo::InvalidPostType if obj.nil? || (obj.is_a?(EfoNelfo::PostType) && obj.post_type != post_type)

      # Set the index if the post has an index property
      obj.index = size + 1 if obj.has_property?(:index)

      @list << obj
    end

    def delete(index)
      @list.delete_at index
    end

    def to_a
      map(&:to_a).flatten(1)
    end

    private
    attr_reader :list

    def post_type_class
      Kernel.const_get("EfoNelfo::V#{owner.class.version_from_class}::#{post_type}")
    end


  end

end

