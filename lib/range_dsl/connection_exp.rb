require 'range_dsl'

module RangeDsl
  module ConnectionExp
    module Client
      def and(right)
        And.new(self, right)
      end
      def or(right)
        Or.new(self, right)
      end
      alias_method :&, :and
      alias_method :|, :or
    end

    class Base
      include Client

      attr_accessor :left, :right
      def initialize(left, right)
        @left, @right = left, right # P, Q
      end
    end

    class And < Base
      def include?(v)
        left.include?(v) && right.include?(v)
      end
    end

    class Or < Base
      def include?(v)
        left.include?(v) || right.include?(v)
      end
    end
  end
end
