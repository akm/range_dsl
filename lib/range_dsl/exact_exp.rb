require 'range_dsl'

module RangeDsl
  module ExactExp
    class Equal
      attr_accessor :value
      def initialize(value)
        @value = value
      end

      def include?(v)
        return true if v == @value
        return true if @value.is_a?(Numeric) && v.is_a?(Numeric) && (v.to_f == @value.to_f)
        false
      end
    end

    class NotEqual < Equal
      def include?(v)
        !super
      end
    end

  end
end
