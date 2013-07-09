module EfoNelfo

  class PostType
    include EfoNelfo::Properties
    include EfoNelfo::HasMany

    class << self

      def for(type, version)
        klass = "EfoNelfo::V#{version_to_namespace(version)}::#{type}"
        const_get(klass) rescue nil
      end

      # Converts version to module version name
      # Example: version_to_namespace("4.2")   # => "42"
      def version_to_namespace(version)
        version.gsub('.', '')
      end

      # Extracts version number from class namespace.
      # Example: EfoNelfo::V41::Some::Class.version  # => "4.1"
      def version
        (version_from_class.to_f / 10).to_s
      end

      def version_from_class
        self.to_s.match(/::V(?<version>\d+)::/)[:version]
      end

      def post_type
        name.split(/::/).last
      end

      def from(hash)
        self.for(hash[:post_type], hash[:version]).new(hash)
      end

      def parse(csv)
        new EfoNelfo::Reader::CSV.new(data: csv).first
      end

    end

    def initialize(*args)
      if args && args.first.is_a?(Array)
        initialize_attributes Hash[properties.keys.zip(args.first)]
      else
        initialize_attributes(*args)
      end
    end

    def post_type
      self.class.post_type
    end

    def version
      self.class.version
    end

    def to_csv
      CSV.generate EfoNelfo::Reader::CSV::CSV_OPTIONS do |csv|
        to_a.each do |row|
          csv << row unless row.empty?
        end
      end
    end

  end

end
