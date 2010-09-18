module RangeDsl

  autoload :OpenRangeExp, 'range_dsl/open_range_exp'
  autoload :ExactExp, 'range_dsl/exact_exp'
  autoload :FilterExp, 'range_dsl/filter_exp'
  autoload :ConnectionExp, 'range_dsl/connection_exp'
  autoload :ContainerExp, 'range_dsl/container_exp'

  def greater_than_equal(v); OpenRangeExp::GreaterThanEqual.new(v); end
  def greater_than(v)      ; OpenRangeExp::GreaterThan.new(v); end
  def less_than_equal(v)   ; OpenRangeExp::LessThanEqual.new(v); end
  def less_than(v)         ; OpenRangeExp::LessThan.new(v); end
  def equal(v)    ; ExactExp::Equal.new(v); end
  def not_equal(v); ExactExp::NotEqual.new(v); end
  def invert(exp) ; FilterExp::Invert.new(exp); end
  def any(*args); ContainerExp::Any.new(*args); end
  def all(*args); ContainerExp::All.new(*args); end

  alias_method :gte, :greater_than_equal
  alias_method :gt, :greater_than
  alias_method :lte, :less_than_equal
  alias_method :lt, :less_than
  alias_method :eq, :equal
  alias_method :neq, :not_equal
  alias_method :not_be, :invert
  alias_method :nb, :invert

  class << self
    def include?(exp, v)
      if exp.is_a?(Array)
        exp.any?{|e| include?(e, v)}
      elsif exp.respond_to?(:include?)
        exp.include?(v)
      else
        exp == v
      end
    end

    def equal_with_considering_numeric(left, right)
      return true if left == right
      return true if left.is_a?(Numeric) && right.is_a?(Numeric) && (left.to_f == right.to_f)
      false
    end
  end

end
