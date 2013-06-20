require 'forwardable'

module EfoNelfo

  class Array
    include Enumerable
    extend Forwardable

    attr_reader :owner, :post_type

    def_delegators :@list, :[], :each, :last, :size, :empty?

    def initialize(*args)
      @owner     = args[0]
      @post_type = args[1]
      @list      = []
    end

    def <<(obj)
      raise EfoNelfo::InvalidPostType if obj.is_a?(EfoNelfo::PostType) && obj.post_type != post_type
      @list << obj
    end

    def to_a
      map(&:to_a).flatten(1)
    end

    protected
    attr_reader :list

  end

end

