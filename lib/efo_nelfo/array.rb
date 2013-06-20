require 'forwardable'

module EfoNelfo

  class Array
    include Enumerable
    extend Forwardable

    attr_reader :owner

    def_delegators :@list, :[], :each, :<<, :last, :size, :empty?

    def initialize(*args)
      @owner = args.first
      @list  = []
    end

    def to_a
      map(&:to_a).flatten(1) #.reject(&:empty?)
    end

    protected
    attr_reader :list

  end

end

