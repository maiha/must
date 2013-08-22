require 'spec_helper'

describe Must::Rule, "coerced" do
  let(:obj) { {"xyz" => ["a","b"] } }

  describe "is_a" do
    specify "[OK]" do
      1.must.be.coerced(Integer).should == 1
      1.must.be.coerced(Integer, String).should == 1
      1.must.be.coerced(String, Numeric).should == 1
    end

    specify "[NG]" do
      lambda { "1".must.be.coerced(Integer) }.should raise_error(Must::Invalid)
      lambda { "1".must.be.coerced(Integer, Range) }.should raise_error(Must::Invalid)
      lambda { "1".must.be.coerced(Integer){raise NotImplementedError} }.should raise_error(NotImplementedError)
    end
  end

  describe "coercing" do
    specify "[OK]" do
      1.must.be.coerced(Integer, String=>proc{|i|i.to_i}).should == 1
      "1".must.be.coerced(Integer, String=>proc{|i|i.to_i}).should == 1
      "1".must.be.coerced(Integer, String=>proc{|i|i.to_i}, Range=>proc{|i|i.first}).should == 1
      "1".must.be.coerced(Integer, Range, String=>proc{|i|i.to_i}, Range=>proc{|i|i.first}).should == 1
      "1".must.be.coerced(File, Integer, Range, String=>proc{|i|i.to_i}, Range=>proc{|i|i.first}).should == 1
    end

    specify "[NG]" do
      lambda { "1".must.be.coerced(Integer, String=>proc{|i| /a/}) }.should raise_error(Must::Invalid)
      lambda { "1".must.be.coerced(Integer, String=>proc{|i| /a/}) {raise NotImplementedError}  }.should raise_error(NotImplementedError)
    end
  end

  describe "cascaded" do
    specify "[OK]" do
      1.must.be.coerced(Integer, Symbol=>:to_s, String=>:to_i).should == 1
      "1".must.be.coerced(Integer, Symbol=>:to_s, String=>:to_i).should == 1
      :"1".must.be.coerced(Integer, Symbol=>:to_s, String=>:to_i).should == 1
    end

    specify "[NG] detect livelock" do
      lambda {"1".must.be.coerced(Integer, Symbol=>:to_s, String=>:intern)}.should raise_error(Must::Invalid)
      lambda {:"1".must.be.coerced(Integer, Symbol=>:to_s, String=>:intern)}.should raise_error(Must::Invalid)
    end
  end
end
