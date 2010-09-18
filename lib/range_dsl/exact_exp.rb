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
    end

    class NotEqual < Equal
      def include?(v)
        !super
      end
    end

  end
end
