module Grape
  module Util
    class InheritableValues
      def initialize(inherited_values = {})
        self.inherited_values = inherited_values
        self.new_values = LoggingValue.new
      end

      def inherited_values=(value)
        reset!
        @inherited_values = value
      end

      def inherited_values
        reset!
        @inherited_values
      end

      def new_values
        reset!
        @new_values
      end

      def new_values=(value)
        reset!
        @new_values = value
      end

      def [](name)
        reset!
        values[name]
      end

      def []=(name, value)
        reset!
        new_values[name] = value
      end

      def delete(key)
        reset!
        new_values.delete key
      end

      def merge(new_hash)
        values.merge(new_hash)
      end

      def keys
        @keys ||= (new_values.keys + inherited_values.keys).sort.uniq
      end

      def to_hash
        values.clone
      end

      def initialize_copy(other)
        super
        self.inherited_values = other.inherited_values
        self.new_values = other.new_values.deep_dup
      end

      protected

      attr_writer :new_values

      def reset!
        @keys = nil
        @values = nil
      end

      def values
        begin
          result = LoggingValue.new

          @inherited_values.keys.each_with_object(result) do |key, res|
            begin
              res[key] = @inherited_values[key].clone
            rescue
              res[key] = @inherited_values[key]
            end
          end

          result.merge(@new_values)
        end
      end
    end
  end
end
