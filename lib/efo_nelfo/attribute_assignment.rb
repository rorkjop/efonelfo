module EfoNelfo

  module AttributeAssignment
    def initialize_attributes(*args)
      if args && args.first.is_a?(Hash)
        args.first.each do |attr, value|
          send "#{attr}=", value
        end
      end
    end
  end

end
