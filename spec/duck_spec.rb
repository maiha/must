require 'spec_helper'

describe Must::Rule, "duck" do
  class CFoo
    def foo; 1; end

    private
      def pfoo; 2; end
  end

  module MFoo
    def foo; 1; end

    private
      def pfoo; 2; end
  end

  describe "duck typing test" do
    specify "[OK]" do
      1.must.duck(:to_s  ).should == 1
      1.must.duck("to_s" ).should == 1
      1.must.duck(".to_s").should == 1

      CFoo.must.duck(:to_s  ).should == CFoo
      CFoo.must.duck("to_s" ).should == CFoo
      CFoo.must.duck(".to_s").should == CFoo

      MFoo.must.duck(:to_s  ).should == MFoo
      MFoo.must.duck("to_s" ).should == MFoo
      MFoo.must.duck(".to_s").should == MFoo

      foo = CFoo.new
      foo.must.duck("foo").should == foo
      foo.must.duck("pfoo").should == foo
    end

    specify "[NG]" do
      lambda { 1.must.duck(:foo  ) }.should raise_error(Must::Invalid)
      lambda { 1.must.duck("foo" ) }.should raise_error(Must::Invalid)
      lambda { 1.must.duck(".foo") }.should raise_error(Must::Invalid)
        
      lambda { CFoo.must.duck(:foo  ) }.should raise_error(Must::Invalid)
      lambda { CFoo.must.duck("foo" ) }.should raise_error(Must::Invalid)
      lambda { CFoo.must.duck(".foo") }.should raise_error(Must::Invalid)

      lambda { MFoo.must.duck(:foo  ) }.should raise_error(Must::Invalid)
      lambda { MFoo.must.duck("foo" ) }.should raise_error(Must::Invalid)
      lambda { MFoo.must.duck(".foo") }.should raise_error(Must::Invalid)
    end
  end

  context "(instance duck typing)" do
    specify "[OK]" do
      CFoo.must.duck("#foo").should == CFoo
      MFoo.must.duck("#foo").should == MFoo
    end

    specify "[NG]" do
      lambda { 1.must.duck("#bar")    }.should raise_error(Must::Invalid)
      lambda { CFoo.must.duck("#bar") }.should raise_error(Must::Invalid)
      lambda { MFoo.must.duck("#bar") }.should raise_error(Must::Invalid)
    end

    specify "cannot invoke private methods" do
      lambda { CFoo.must.duck("#pfoo") }.should raise_error(Must::Invalid)
      lambda { MFoo.must.duck("#pfoo") }.should raise_error(Must::Invalid)
    end
  end

  context "(duck bang)" do
    specify "[OK]" do
      1.must.duck!("to_s").should == "1"

      foo = CFoo.new
      foo.must.duck!("foo").should == 1
      foo.must.duck!("pfoo").should == 2
    end

    specify "[NG]" do
      lambda { 1.must.duck!("foo") }.should raise_error(Must::Invalid)
    end

    specify "callback" do
      1.must.duck!("to_xxx") { 2 }
    end
  end
end
