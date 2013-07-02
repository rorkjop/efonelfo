module EfoNelfo
  class Property
    VALID_OPTIONS = [:type, :required, :limit, :read_only, :alias, :default, :decimals]

    attr_reader :name, :default, :type, :required, :value, :decimals

    def initialize(name, defaults={})
      options = {
        type: :string,
        required: false
      }
      options.update(defaults) if defaults.is_a?(Hash)

      invalid_options = options.keys - VALID_OPTIONS
      raise EfoNelfo::UnknownPropertyOption.new("Invalid option for #{name}: #{invalid_options.join(',')}") if invalid_options.any?

      @name     = name
      @default  = options[:default]
      @type     = options[:type]
      @required = options[:required]
      @decimals = options[:decimals]
      @value    = default
    end

    def value=(v)
      @value = v
    end

    def to_f
      decimals.nil? ? value.to_f : value.to_f * (1.0/10**decimals.to_i)
    end

  end

end
