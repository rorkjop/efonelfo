module EfoNelfo

  module HasMany

    def self.included(base)
      base.send :extend, ClassMethods
    end

    def find_association(post_type)
      send self.class.association(post_type) if has_association?(post_type)
    end

    def has_association?(post_type)
      !self.class.association(post_type).nil?
    end

    def associations
      self.class.associations
    end

    def add(post)
      find_association(post) << post
    end

    def to_a
      [ super ] + associations_array
    end

    protected

    def associations_array
      if associations
        associations.keys.map { |name| find_association(name).to_a }.reject(&:empty?).flatten(1)
      else
        []
      end
    end

    module ClassMethods

      def has_many(name, options)
        post_type = options[:post_type]

        @associations ||= {}
        @associations[post_type] = name

        define_method name do
          instance_variable_get("@#{name}") || instance_variable_set("@#{name}", EfoNelfo::Collection.new(self, post_type))
        end

        define_method "#{name}=" do |values|
          instance_variable_set "@#{name}", EfoNelfo::Collection.new(self, post_type)
          values.each { |item| instance_variable_get("@#{name}") << item } if values
        end

      end

      def associations
        @associations
      end

      def association(post_type)
        type = post_type.is_a?(EfoNelfo::PostType) ? post_type.post_type : post_type.to_s.upcase
        @associations[type]
      end
    end

  end

end
