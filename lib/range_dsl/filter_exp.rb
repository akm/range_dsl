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

      def eql?(other)
        (other.class == self.class) && self.src.eql?(other.src)
      end
      alias_method :==, :eql?

      def hash
        "#{self.class.name}:#{inspect}".hash
      end
    end

    class Func
      include ConnectionExp::Client

      attr_reader :block_str
      def initialize(block_str = nil, &block)
        @block_str = block_str
        @block = block
      end

      def include?(v)
        !!@block.call(v)
      end

      def inspect
        "func" << (@block_str ? "(#{@block_str.inspect})" : '{}')
      end

      def eql?(other)
        return false if @block_str.nil?
        (other.class == self.class) && self.block_str.eql?(other.block_str)
      end
      alias_method :==, :eql?

      def hash
        "#{self.class.name}:#{inspect}".hash
      end
    end

  end
end
