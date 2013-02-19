module EfoNelfo

  module Property

    def self.included(base)
      base.send :extend, ClassMethods
    end

    def valid?
      true
    end

    module ClassMethods
      def property(name, options={})
        attr_accessor name

        if options[:alias]
          define_method(options[:alias]) do
            send name
          end

          define_method("#{options[:alias]}=") do |val|
            send "#{name}=", val
          end
        end
      end
    end

  end

end
