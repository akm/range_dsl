module RangeDsl

  autoload :OpenRangeExp, 'range_dsl/open_range_exp'
  autoload :ExactExp, 'range_dsl/exact_exp'

  def greater_than_equal(v); OpenRangeExp::GreaterThanEqual.new(v); end
  def greater_than(v)      ; OpenRangeExp::GreaterThan.new(v); end
  def less_than_equal(v)   ; OpenRangeExp::LessThanEqual.new(v); end
  def less_than(v)         ; OpenRangeExp::LessThan.new(v); end

  def equal(v)    ; ExactExp::Equal.new(v); end
  def not_equal(v); ExactExp::NotEqual.new(v); end

  alias_method :gte, :greater_than_equal
  alias_method :gt, :greater_than
  alias_method :lte, :less_than_equal
  alias_method :lt, :less_than

  alias_method :eq, :equal
  alias_method :not, :not_equal

end
