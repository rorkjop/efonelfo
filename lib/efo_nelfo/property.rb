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

    def value=(new_value)
      return nil if readonly?

      @value = case
        when boolean?
          new_value.nil? || new_value == true || new_value == 'J' || new_value == 'j' || new_value == '' ? true : false
        when date?
          new_value.is_a?(Date) ? new_value : Date.parse(new_value) rescue nil
        when integer?
          new_value.nil? ? nil : new_value.to_i
        else
          new_value
      end
    end

    # returns formatted value suitable for csv output
    def to_csv
      output = value.to_csv
    end

    def to_f
      return nil if value.nil?
      value.to_f.with_decimals decimals
    end

    def readonly?
      options[:read_only]
    end

    def required?
      options[:required]
    end

    def boolean?; type == :boolean; end
    def date?;    type == :date;    end
    def integer?; type == :integer; end
    def string?;  type == :string;  end

    def method_missing(*args)
      options.has_key?(args.first) ? options[args.first] : super
    end

  end

end
