module EfoNelfo

  class Array < ::Array
    def to_a
      map(&:to_a).flatten(1)
      # arr = []
      # each { |line| arr += line.to_a }
      # arr
    end
  end

end

