require 'range_dsl'

module RangeDsl
  module ExactExp
    class Equal
      include ConnectionExp::Client

      attr_accessor :value
      def initialize(value)
        @value = value
      end

      def include?(v)
        RangeDsl.equal_with_considering_numeric(@value, v)
      end

      def inspect
        "eq(#{@value.inspect})"
      end

      def eql?(other)
        (other.value == self.value) && (other.class == self.class)
      end
      alias_method :==, :eql?

      def hash
        "#{self.class.name}:#{inspect}".hash
      end
    end

    class NotEqual < Equal
      def include?(v)
        !super
      end

      def inspect
        "neq(#{@value.inspect})"
      end
    end

  end
end
