module EfoNelfo

  class Array < ::Array
    def to_a
      map(&:to_a).flatten(1)
    end
  end

end

