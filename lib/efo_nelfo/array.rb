require 'forwardable'

module EfoNelfo

  class Array
    include Enumerable
    extend Forwardable

    def_delegators :@list, :each, :<<, :last

    def initialize(*args)
      @list = []
    end

    def to_a
      map(&:to_a).flatten(1)
    end

    protected
    attr_reader :list

  end

end

