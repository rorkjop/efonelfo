module EfoNelfo

  module Property
    include EfoNelfo::AttributeAssignment

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

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
        raise EfoNelfo::DuplicateProperty if @properties.has_key?(name)
        @properties[name] = options

        # Add an attr_accessor
        attr_accessor name

        # Define custom setter method
        if options[:type] != String
          define_setter_method_for_type(name, options[:type])
        end

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

      def properties
        @properties
      end

      private

      def define_setter_method_for_type(name, type)
        send "define_#{type.to_s.downcase}_setter", name
      end

      def define_integer_setter(name)
        define_method("#{name}=") do |val|
          instance_variable_set :"@#{name}", val.to_i
        end
      end

      def define_boolean_setter(name)
        define_method("#{name}=") do |val|
          value = val.nil? || val == 'J'
          instance_variable_set :"@#{name}", value
        end
      end

      def define_date_setter(name)
        define_method("#{name}=") do |val|
          date = Date.parse(val) rescue nil
          instance_variable_set :"@#{name}", date
        end
      end

    end

  end

end
