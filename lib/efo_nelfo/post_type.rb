module EfoNelfo

  class PostType
    include EfoNelfo::Property
    include EfoNelfo::AttributeAssignment

    @modules = []

    class << self
      def inherited(klass)
        @modules << klass
      end

      def for(type, version)
        @modules.select { |mod| mod.can_parse?(type, version) }.first
      end
    end

    def initialize(*args)
      initialize_attributes *args
      if args && args.first.is_a?(Array)
        parse args.first
      end

      # if args && args.first.is_a?(Hash)
      #   args.first.each do |attr, value|
      #     send "#{attr}=", value
      #   end
      # elsif args && args.first.is_a?(Array)
      #   parse(args.first)
      # end
    end

    def parse(row)
      # implemented in subclasses
    end

  end

end
