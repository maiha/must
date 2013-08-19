require 'spec_helper'

describe Must::StructInfo do
  def struct(obj)
    Must::StructInfo.new(obj)
  end

  ######################################################################
  ### same?

  describe "#same?" do
    specify do
      struct(1      ).same?(Integer).should == true
      struct(1      ).same?(Numeric).should == true
      struct(String ).same?(Integer).should == false

      struct(Integer).same?(Integer).should == true
      struct(Integer).same?(Numeric).should == true
      struct(Fixnum ).same?(1      ).should == true
    end
  end

  ######################################################################
  ### types

  describe "#types" do
    specify do
      struct(1).types.should == [Fixnum]
      struct(:a=>{"1"=>0.25}).types.should == [Hash, Symbol, String, Float]
    end
  end

  ######################################################################
  ### struct

  describe "#compact" do
    specify do
      struct(1  ).compact.should == Fixnum
      struct({} ).compact.should == Hash
      struct([] ).compact.should == Array
      struct([1]).compact.should == [Fixnum]

      struct( "a"=>1       ).compact.should == {String=>Fixnum}
      struct( [{"1"=>0.2}] ).compact.should == [{String=>Float}]

      struct( "1.1" => {"jp"=>[{:a=>0},{:b=>2}]} ).compact.should == {String=>{String=>[{Symbol=>Fixnum}]}}
    end

    specify "array is represented by first element for speed" do
      struct([1, "a"]).compact.should == [Fixnum]
      struct(["a", 1]).compact.should == [String]
    end
  end

  ######################################################################
  ### inspect

  describe "#inspect" do
    specify do
      struct(1  ).inspect.should == "Fixnum"
      struct({} ).inspect.should == "Hash"
      struct([] ).inspect.should == "Array"
      struct([1]).inspect.should == "[Fixnum]"

      struct( "a"=>1   ).inspect.should == "{String=>Fixnum}"
      struct(["1"=>0.1]).inspect.should == "[{String=>Float}]"

      struct( "1.1" => {"jp"=>[{:a=>0},{:b=>2}]} ).inspect.should == "{String=>{String=>[{Symbol=>Fixnum}]}}"
    end
  end

end
