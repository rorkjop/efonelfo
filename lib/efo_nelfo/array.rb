module EfoNelfo

  class Array < ::Array
    def to_a
      # map(&:to_a)[0]
      arr = []
      each { |i| arr += i.to_a }

      arr
      # map &:to_a
    end
  end

end

