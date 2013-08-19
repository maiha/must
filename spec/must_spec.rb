require 'spec_helper'

describe Must::Rule, "must" do
  def ok(&block)
    block.should_not raise_error
  end

  def ng(error = Must::Invalid, &block)
    block.should raise_error(error)
  end

  ######################################################################
  ### must be

  describe "be" do
    specify "[OK]" do
      1.must.be(1).should == 1
      [1,2,3].must.be([1,2,3]).should == [1,2,3]
      {:a=>1, "b"=>2}.must.be({:a=>1, "b"=>2}).should == {:a=>1, "b"=>2}
      String.must.be(String).should == String
    end

    specify "[NG]" do
      ng {1.must.be 2}
    end

    specify "callback" do
      1.must.be(2){:error}.should == :error
    end
  end

  ######################################################################
  ### must not be blank

  describe "not be blank" do
    if Object.instance_methods.include?("blank?")
      specify do
        "ok".must.not.be.blank.should == "ok"
        "ok".must.not.be.blank{"ng"}.should == "ok"
        "".must.not.be.blank{"ng"}.should == "ng"
        ng { "".must.not.be.blank }
      end
    end
  end


  ######################################################################
  ### must(type)

  describe "type" do
    specify do
      "ok".must(String).should == "ok"
      "ok".must(Integer, String).should == "ok"
      ng { "ok".must(Integer) }
    end

    specify "weird but it is" do
      # NOTE: this passes because 1(integer) is a kind of 2(integer)
      ok { 1.must(2) }
    end

    specify "callback" do
      "ok".must(Integer){:error}.should == :error
    end
  end

  ######################################################################
  ### kind_of

  describe "kind_of" do
    specify do
      "ok".must.be.kind_of(String).should == "ok"
      ng {"ok".must.be.kind_of(Integer)}
    end

    specify "multiple args" do
      "ok".must.be.kind_of(Integer,String).should == "ok"
      "ok".must.be.kind_of(String,Integer).should == "ok"
      ng { "ok".must.be.kind_of(Integer, Array) }
    end
  end
end
