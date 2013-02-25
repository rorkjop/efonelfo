class Order
  def initialize
    @lines = [ ['c', 'd'] ]
    @attrs = [ 'a', 'b' ]
  end

  def to_a
    # [ @attrs ] << lines
    arr = [ @attrs ]
    lines.each do |i|
      arr += i
    end
    arr
  end

  def lines
    @lines
  end

  def to_csv
    to_a
  end
end


puts Order.new.to_csv.inspect
