module EfoNelfo

  class PostType
    include EfoNelfo::Property

    @modules = []

    class << self

      def inherited(klass)
        puts "Adding #{klass}"
        @modules << klass
      end

      def for(type, version)
        @modules.select do |mod|
          mod.can_parse?(type, version)
        end.first
      end
    end

    def initialize(*args)
      if args && args.first.is_a?(Array)
        parse(args.first)
      end
    end

    def parse(row)
      # implemented in subclasses
    end

  end

end
