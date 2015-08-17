module EfoNelfo

  module Properties

    def self.included(base)
      base.send :extend, ClassMethods
    end

    def initialize_attributes(*args)
      if args && args.first.is_a?(Hash)
        args.first.each do |attr, value|
          send "#{attr}=", value
        end
      end
    end

    # Returns all properties
    def properties
      @properties ||= initialize_properties
    end
    alias :attributes :properties

    # Returns true if the given property exists
    def has_property?(name)
      properties.include? name
    end

    # Returns all property values as array formatted for csv
    def to_a
      properties.values.map(&:to_csv)
    end

    private

    def initialize_properties
      self.class.properties.inject({}) do |hash,(name,options)|
        hash[name] = EfoNelfo::Property.new(name, options)
        hash
      end
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

        name       = name.to_sym
        alias_name = options.delete(:alias)

        # ensure all options are valid
        EfoNelfo::Property.validate_options! options

        # ensure property is unique
        raise EfoNelfo::DuplicateProperty if properties.has_key?(name)

        # setup getters and setters
        create_reader_for(name, options)
        create_setter_for(name, options) unless options[:read_only]
        create_question_for(name)        if options[:type] == :boolean
        create_alias_for(name, alias_name, options)  if alias_name

        properties[name] = options
      end

      # Returns all properties defined for the class
      def properties
        @_properties ||= {}
      end

      private

      # Creates an attribute accessor for the property
      def create_reader_for(name, options)
        define_method name do
          attributes[name].value
        end
      end

      # Creates an attribute setter for the property
      def create_setter_for(name, options)
        define_method "#{name}=" do |value|
          attributes[name].value = value
        end
      end

      # Creates a name? accessor for the property
      # Only applies to boolean types
      def create_question_for(name)
        define_method "#{name}?" do
          attributes[name].value == true
        end
      end

      # Create an alias getter/setter for the property
      def create_alias_for(name, alias_name, options)
        define_method(alias_name) do
          send name
        end

        unless options[:read_only]
          define_method("#{alias_name}=") do |val|
            send "#{name}=", val
          end
        end
      end

    end

  end

end
