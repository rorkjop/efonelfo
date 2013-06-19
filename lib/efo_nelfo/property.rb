module EfoNelfo

  module Property
    include EfoNelfo::AttributeAssignment

    def self.included(base)
      base.send :extend, ClassMethods
    end

    def attributes
      @attributes ||= initialize_default_attributes
    end

    def properties
      self.class.properties
    end

    def to_a
      properties.keys.map { |prop| formatted_for_csv(prop) }
    end

    private

    def initialize_default_attributes
      properties.inject({}) { |h,(name,options)| h[name] = options[:default]; h }
    end

    def format_value(value, type)
      case type
      when :integer
        value.nil? ? nil : value.to_i
      when :date
        if value.nil?
          nil
        elsif value.kind_of? String
          Date.parse value
        else
          value
        end
      when :boolean
        value.nil? || value == true || value == 'J' || value == '' ? true : false
      else
        value
      end
    end

    # Format value for given attribute
    def formatted_for_csv(attr)

      if respond_to?("format_#{attr}")
        value = send "format_#{attr}"
      else
        value = send attr

        type  = properties[attr][:type]

        value = case type
        when :date
          value ? value.strftime("%Y%m%d") : nil
        when :boolean
          value == true ? "J" : nil
        else
          value
        end
      end
      value.respond_to?(:encode) ? value.encode(Encoding::ISO_8859_1) : value
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
          type: :string,
          required: false,
        }.update options

        name = name.to_sym

        # ensure all options are valid
        valid_options   = [:type, :required, :limit, :read_only, :alias, :default]
        invalid_options = options.keys - valid_options
        raise EfoNelfo::UnknownPropertyOption.new("Invalid option for #{name}: #{invalid_options.join(',')}") if invalid_options.any?

        # Store property info in @properties
        raise EfoNelfo::DuplicateProperty if properties.has_key?(name)
        properties[name] = options

        create_reader_for(name, options)
        create_setter_for(name, options) unless options[:read_only]
        create_question_for(name)        if options[:type] == :boolean
        create_alias_for(name, options)  if options[:alias]
      end

      # Returns all properties
      def properties
        @_properties ||= {}
      end

      private

      # Creates an attribute accessor for name
      def create_reader_for(name, options)
        define_method name do
          attributes[name]
        end
      end

      # Creates an attribute setter for name
      def create_setter_for(name, options)
        define_method "#{name}=" do |value|
          attributes[name] = format_value(value, options[:type])
        end
      end

      # Creates a name? accessor
      def create_question_for(name)
        define_method "#{name}?" do
          attributes[name] == true
        end
      end

      def create_alias_for(name, options)
        define_method(options[:alias]) do
          send name
        end

        unless options[:read_only]
          define_method("#{options[:alias]}=") do |val|
            send "#{name}=", val
          end
        end
      end

    end

  end

end
