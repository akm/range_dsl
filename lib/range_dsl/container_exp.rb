require 'range_dsl'

module RangeDsl
  module ContainerExp
    class Base
      include ConnectionExp::Client

      attr_accessor :values
      def initialize(*args)
        @values = (args.length == 1 && args.first.is_a?(Array)) ? args.first : args
      end
    end

    class Any < Base
      def include?(v)
        @values.any?{|value| RangeDsl.include?(value, v) }
      end
    end

    class All < Base
      def include?(v)
        @values.all?{|value| RangeDsl.include?(value, v) }
      end
    end
  end
end
