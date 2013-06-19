module EfoNelfo

  class PostType
    include EfoNelfo::Property

    class << self

      def for(type, version)
        klass = "EfoNelfo::V#{version_to_namespace(version)}::#{type}"
        const_get(klass) rescue nil
      end

      # Converts version to module version name
      # Example: version_to_namespace("4.2")   # => "42"
      def version_to_namespace(version)
        version.to_s.gsub('.', '')
      end

      # Extracts version number from class namespace.
      # Example: EfoNelfo::V41::Some::Class.version  # => "4.1"
      def version
        (self.to_s.match(/::V(?<version>\d+)::/)[:version].to_f / 10).to_s
      end

      def post_type
        name.split(/::/).last
      end

    end

    def initialize(*args)
      initialize_attributes *args
    end

    def post_type
      self.class.post_type
    end

    def version
      self.class.version
    end

    # This is for adding posttypes
    def add(something)
    end

  end

end
