require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RangeDsl" do
  before(:all) do
    @context = Object.new
    @context.extend(RangeDsl)
  end

  describe "introduction" do
    describe "easy open range" do
      describe "gte" do
        [:gte, :greater_than_equal].each do |operator|
          it operator do
            @r1 = @context.send(operator, 100)
            @r1.include?(99).should == false
            @r1.include?(100).should == true
            @r1.include?(100.0).should == true
            @r1.include?(1234567890).should == true
          end
        end
      end

      describe "gt" do
        [:gt, :greater_than].each do |operator|
          it operator do
            @r1 = @context.send(operator, 100)
            @r1.include?(99).should == false
            @r1.include?(100).should == false
            @r1.include?(100.0).should == false
            @r1.include?(1234567890).should == true
          end
        end
      end

      describe "lte" do
        [:lte, :less_than_equal].each do |operator|
          it operator do
            @r1 = @context.send(operator, 100)
            @r1.include?(-1234567890).should == true
            @r1.include?(99).should == true
            @r1.include?(99.99).should == true
            @r1.include?(100).should == true
            @r1.include?(100.0).should == true
            @r1.include?(100.000001).should == false
            @r1.include?(101).should == false
          end
        end
      end

      describe "lt" do
        [:lt, :less_than].each do |operator|
          it operator do
            @r1 = @context.send(operator, 100)
            @r1.include?(-1234567890).should == true
            @r1.include?(99).should == true
            @r1.include?(99.99).should == true
            @r1.include?(100).should == false
            @r1.include?(100.0).should == false
            @r1.include?(100.000001).should == false
            @r1.include?(101).should == false
          end
        end
      end
    end

    describe "just equal, or just not equal" do
      describe "eq" do
        [:eq, :equal].each do |operator|
          it operator do
            @r1 = @context.send(operator, 100)
            @r1.include?(99).should == false
            @r1.include?(99.9999).should == false
            @r1.include?(100.0).should == true
            @r1.include?(100).should == true
            @r1.include?(100.0001).should == false
            @r1.include?(101).should == false
          end
        end
      end

      describe "lt" do
        [:not, :not_equal].each do |operator|
          it operator do
            @r1 = @context.send(operator, 100)
            @r1.include?(99).should == true
            @r1.include?(99.9999).should == true
            @r1.include?(100.0).should == false
            @r1.include?(100).should == false
            @r1.include?(100.0001).should == true
            @r1.include?(101).should == true
          end
        end
      end
    end

    describe "complex pattern" do
      describe "gt(3) & lt(6)" do
        ["gt(3).and(lt(6))", "gt(3) & lt(6)"].each do |dsl|
          it dsl do
            @r2 = @context.instance_eval(dsl)
            @r2.include?(2).should == false
            @r2.include?(2.999).should == false
            @r2.include?(3).should == false
            @r2.include?(3.0).should == false
            @r2.include?(3.1).should == true
            @r2.include?(4).should == true
            @r2.include?(5).should == true
            @r2.include?(5.9).should == true
            @r2.include?(6.0).should == false
            @r2.include?(6).should == false
            @r2.include?(6.1).should == false
            @r2.include?(7).should == false
          end
        end
      end

      describe "gte(3) & lte(6)" do
        ["gte(3).and(lte(6))", "gte(3) & lte(6)"].each do |dsl|
          it dsl do
            @r2 = @context.instance_eval(dsl)
            @r2.include?(2).should == false
            @r2.include?(2.999).should == false
            @r2.include?(3).should == true
            @r2.include?(3.0).should == true
            @r2.include?(3.1).should == true
            @r2.include?(4).should == true
            @r2.include?(5).should == true
            @r2.include?(5.9).should == true
            @r2.include?(6.0).should == true
            @r2.include?(6).should == true
            @r2.include?(6.1).should == false
            @r2.include?(7).should == false
          end
        end
      end

      describe "lt(3) | gt(6)" do
        ["lt(3).or(gt(6))", "lt(3) | gt(6)"].each do |dsl|
          it dsl do
            @r2 = @context.instance_eval(dsl)
            @r2.include?(2).should == true
            @r2.include?(2.999).should == true
            @r2.include?(3).should == false
            @r2.include?(3.0).should == false
            @r2.include?(3.1).should == false
            @r2.include?(4).should == false
            @r2.include?(5).should == false
            @r2.include?(5.9).should == false
            @r2.include?(6.0).should == false
            @r2.include?(6).should == false
            @r2.include?(6.1).should == true
            @r2.include?(7).should == true
          end
        end
      end

      describe "lte(3) | gte(6)" do
        ["lte(3).or(gte(6))", "lte(3) | gte(6)"].each do |dsl|
          it dsl do
            @r2 = @context.instance_eval(dsl)
            @r2.include?(2).should == true
            @r2.include?(2.999).should == true
            @r2.include?(3).should == true
            @r2.include?(3.0).should == true
            @r2.include?(3.1).should == false
            @r2.include?(4).should == false
            @r2.include?(5).should == false
            @r2.include?(5.9).should == false
            @r2.include?(6.0).should == true
            @r2.include?(6).should == true
            @r2.include?(6.1).should == true
            @r2.include?(7).should == true
          end
        end
      end
    end

  end

end
