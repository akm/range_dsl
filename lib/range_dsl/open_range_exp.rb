require 'range_dsl'

module RangeDsl
  module OpenRangeExp
    POSITIVE_INFINITY = 1.0/0
    NEGATIVE_INFINITY = -1.0/0

    class Base
      include ConnectionExp::Client

      attr_accessor :value
      def initialize(value)
        @value = value
      end

      def include?(v)
        to_range.include?(v)
      end

      def inspect
        "#{name_for_inspect}(#{@value.inspect})"
      end

      def eql?(other)
        (other.value == self.value) && (other.class == self.class)
      end
      alias_method :==, :eql?

      def hash
        "#{self.class.name}:#{inspect}".hash
      end
    end

    class GreaterThanEqual < Base
      def name_for_inspect; "gte"; end
      def to_range
        @range ||= (@value..POSITIVE_INFINITY)
      end
    end

    class GreaterThan < GreaterThanEqual
      def name_for_inspect; "gt"; end
      def include?(v)
        return false if RangeDsl.equal_with_considering_numeric(@value, v)
        to_range.include?(v)
      end
    end

    class LessThanEqual < Base
      def name_for_inspect; "lte"; end
      def to_range
        @range ||= (NEGATIVE_INFINITY..@value)
      end
    end

    class LessThan < Base
      def name_for_inspect; "lt"; end
      def to_range
        @range ||= (NEGATIVE_INFINITY...@value)
      end
    end


  end
end

