module EfoNelfo

  module Property

    def self.included(base)
      base.send :extend, ClassMethods
    end

    def valid?
      true
    end

    module ClassMethods

      def properties
        @properties
      end

      # Creates an attribute with given name.
      #
      # Options
      #   - type      String, Integer etc. Default is String
      #   - required  whether attribute is required. Default is false
      #   - limit     Length the attribute can be. Default is nil
      #   - alias     Norwegian alias name for the attribute
      #
      def property(name, options={})
        options = {
          type: String,
          required: false
        }.update options

        # Store property info in @properties
        @properties ||= {}
        @properties[name] = options

        # Add an attr_accessor
        attr_accessor name

        # Add an alias
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
