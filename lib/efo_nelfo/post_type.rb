module EfoNelfo

  class PostType
    include EfoNelfo::Property
    include EfoNelfo::AttributeAssignment

    attr_reader :post_type

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
    end

    # This is for adding posttypes
    def add(something)
    end

  end

end
