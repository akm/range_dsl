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

      def inspect
        left_str = (require_brace?(@left) ? '(%s)' : '%s') % @left.inspect
        right_str = (require_brace?(@right) ? '(%s)' : '%s') % @right.inspect
        "#{left_str} #{name_for_inspect} #{right_str}"
      end

      private
      def require_brace?(other)
        return false unless other.is_a?(ConnectionExp::Base)
        other.class != self.class
      end
    end

    class And < Base
      def name_for_inspect; "&"; end
      def include?(v)
        left.include?(v) && right.include?(v)
      end
    end

    class Or < Base
      def name_for_inspect; "|"; end
      def include?(v)
        left.include?(v) || right.include?(v)
      end
    end
  end
end
