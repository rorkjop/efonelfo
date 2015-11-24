using EfoNelfo::PropertyTypes

module EfoNelfo

  class Property
    VALID_OPTIONS = [:type, :required, :limit, :read_only, :default, :decimals]
    VALID_TYPES   = [:string, :integer, :boolean, :date]

    attr_reader :name, :options, :value

    def self.validate_options!(options)
      invalid_options = options.keys - VALID_OPTIONS
      raise EfoNelfo::UnknownPropertyOption.new("Invalid options: #{invalid_options.join(',')}") if invalid_options.any?
      raise EfoNelfo::InvalidPropertyType.new("Valid types are #{VALID_TYPES.join(',')}") unless VALID_TYPES.include?(options[:type])
    end

    def initialize(name, defaults={})

      options = {
        type:      :string,
        required:  false,
        default:   nil,
        read_only: false,
        decimals:  nil,
        limit:     100
      }
      options.update(defaults) if defaults.is_a?(Hash)

      self.class.validate_options! options

      @name      = name
      @options   = options
      @value     = options[:default]
    end

    # Assign a value to the property
    # The value is converted to whatever specified by options[:type]
    # Examples:
    #   (boolean) value = 'J'         # => true
    #   (boolean) value = false       # => false
    #   (date)    value = '20120101'  # => Date.new(2012,1,1)
    #   (integer) value = '2'         # => 2
    #   (string)  value = 'foo'       # => 'foo'
    def value=(new_value)
      return nil if readonly?
      @value = send("sanitize_#{options[:type]}", new_value)
    end

    # returns formatted value suitable for csv output
    def to_csv
      value.to_csv
    end

    # Returns integer to floating point based on specified decimals
    # Example:
    #   If decimal is set to 4, and the value is 4000
    #   then to_f returns 0.4
    def to_f
      return nil if value.nil?
      value.to_f.with_decimals decimals
    end
    alias :to_decimal :to_f

    # Returns true if the property is read only
    def readonly?
      options[:read_only] == true
    end

    # Returns true if the property is required
    # Note: this is not in use yet
    def required?
      options[:required] == true
    end

    def boolean?; type == :boolean; end
    def date?;    type == :date;    end
    def integer?; type == :integer; end
    def string?;  type == :string;  end

    def method_missing(*args)
      options.has_key?(args.first) ? options[args.first] : super
    end

    private

    def sanitize_integer(value)
      value.nil? && !required? ? nil : value.to_i
    end

    def sanitize_boolean(value)
      value.nil? || value == true || value == 'J' || value == 'j' || value == '' ? true : false
    end

    def sanitize_date(value)
      value.is_a?(Date) ? value : Date.parse(value) rescue nil
    end

    def sanitize_string(value)
      return value unless value.is_a?(String)
      return nil if /\A[[:space:]]*\z/ === value

      string = value.to_s

      if EfoNelfo.strict_mode? && (options[:limit] && string.length > options[:limit])
        raise ArgumentError.new("Value exceeds limit")
      else
        string.slice(0, options[:limit])
      end

    end

  end

end
