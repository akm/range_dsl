require 'range_dsl'

module RangeDsl
  module FilterExp
    class Invert
      include ConnectionExp::Client

      attr_accessor :src
      def initialize(src)
        @src = src
      end

      def include?(v)
        !src.include?(v)
      end

      def inspect
        "not_be(#{@src.inspect})"
      end
    end

    class Func
      include ConnectionExp::Client

      def initialize(&block)
        @block = block
      end

      def include?(v)
        !!@block.call(v)
      end

      def inspect
        "func{...}"
      end
    end

  end
end
