module EfoNelfo
  class Property
    VALID_OPTIONS = [:type, :required, :limit, :read_only, :default, :decimals]

    attr_reader :name, :options, :value

    def self.validate_options!(options)
      invalid_options = options.keys - VALID_OPTIONS
      raise EfoNelfo::UnknownPropertyOption.new("Invalid options: #{invalid_options.join(',')}") if invalid_options.any?
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

    def readonly?
      options[:read_only]
    end

    def required?
      options[:required]
    end

    def value=(v)
      @value = v unless readonly?
    end

    def to_f
      return nil if value.nil?
      decimals.nil? ? value.to_f : value.to_f * (1.0/10**decimals.to_i)
    end

    def method_missing(*args)
      options.has_key?(args.first) ? options[args.first] : super
    end
  end

end
