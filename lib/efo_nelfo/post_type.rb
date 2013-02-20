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

      def for(type, version=nil)
        @modules.select { |mod| mod.can_parse?(type, version) }.first
      end

      def can_parse?(post_type, check_version=nil)
        if check_version
          self::POST_TYPES.keys.include?(post_type) && check_version == version
        else
          self::POST_TYPES.keys.include?(post_type)
        end
      end

      # Extracts version number from class namespace.
      # Example: EfoNelfo::V41::Some::Class.version  # => "4.1"
      def version
        (self.to_s.match(/::V(?<version>\d+)::/)[:version].to_f / 10).to_s
      end

    end

    def initialize(*args)
      initialize_attributes *args
      @post_type = self.class::POST_TYPES.keys.first
      @version   = self.class.version
    end

    # This is for adding posttypes
    def add(something)
    end

    def post_type_human
      self.class::POST_TYPES[post_type]
    end

  end

end
