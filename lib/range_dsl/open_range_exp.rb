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
    end

    class GreaterThanEqual < Base
      def to_range
        @range ||= (@value..POSITIVE_INFINITY)
      end
    end

    class GreaterThan < GreaterThanEqual
      def include?(v)
        return false if v == @value
        return false if @value.is_a?(Numeric) && v.is_a?(Numeric) && (v.to_f == @value.to_f)
        to_range.include?(v)
      end
    end

    class LessThanEqual < Base
      def to_range
        @range ||= (NEGATIVE_INFINITY..@value)
      end
    end

    class LessThan < Base
      def to_range
        @range ||= (NEGATIVE_INFINITY...@value)
      end
    end


  end
end

