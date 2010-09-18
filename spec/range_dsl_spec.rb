# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RangeDsl" do
  before(:all) do
    @context = Object.new
    @context.extend(RangeDsl)
  end

  describe "introduction" do
    it "1,2と5以上はtrue" do
      r = @context.instance_eval do
        any 1, 2, gte(5)
      end
      r.include?(-10000).should == false
      r.include?(0).should == false
      r.include?(1).should == true
      r.include?(2).should == true
      r.include?(3).should == false
      r.include?(4).should == false
      r.include?(5).should == true
      r.include?(6).should == true
      r.include?(10000).should == true
    end
  end

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
      [:neq, :not_equal].each do |operator|
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

  describe "included in an array" do
    describe "any" do
      ["any(3, 7)", "any [3, 7]"].each do |dsl|
        it dsl do
          @r1 = @context.instance_eval(dsl)
          @r1.include?(2).should == false
          @r1.include?(2.9).should == false
          @r1.include?(3.0).should == true
          @r1.include?(3).should == true
          @r1.include?(3.1).should == false
          @r1.include?(4).should == false
          @r1.include?(5).should == false
          @r1.include?(6).should == false
          @r1.include?(6.9).should == false
          @r1.include?(7.0).should == true
          @r1.include?(7).should == true
          @r1.include?(7.1).should == false
          @r1.include?(8).should == false
        end
      end
    end
  end


  describe "not with other expression" do
    it "not equal(100)" do
      r1 = @context.instance_eval do
        not_be(equal(100))
      end
      r1.include?(99).should == true
      r1.include?(99.9).should == true
      r1.include?(100).should == false
      r1.include?(100.0).should == false
      r1.include?(100.1).should == true
      r1.include?(101).should == true
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
      [
        "gte(3).and(lte(6))",
        "gte(3) & lte(6)",
        "all(gte(3), lte(6))", # allはandの代わりに使えます
        "all [gte(3), lte(6)]", # allはandの代わりに使えます
      ].each do |dsl|
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
      [
        "lt(3).or(gt(6))",
        "lt(3) | gt(6)",
        "any(lt(3), gt(6))", # anyはorの代わりに使えます
        "any [lt(3), gt(6)]", # anyはorの代わりに使えます
      ].each do |dsl|
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
      [
        "lte(3).or(gte(6))",
        "lte(3) | gte(6)",
        # not_be を使う
        "not_be(gt(3) & lt(6))",
        "not_be(gt(3).and(lt(6)))",
        # 更にド・モルガンの法則で展開
        "not_be(gt(3)) | not_be(lt(6))",
        "not_be(gt(3)).or(not_be(lt(6)))",
      ].each do |dsl|
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
