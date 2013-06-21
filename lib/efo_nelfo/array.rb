require 'forwardable'

module EfoNelfo

  class Array
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
      raise EfoNelfo::InvalidPostType if obj.is_a?(EfoNelfo::PostType) && obj.post_type != post_type
      @list << obj if obj
    end

    def post_type_class
      Kernel.const_get("EfoNelfo::V#{owner.class.version_from_class}::#{post_type}")
    end

    def to_a
      map(&:to_a).flatten(1)
    end

    protected
    attr_reader :list

  end

end

