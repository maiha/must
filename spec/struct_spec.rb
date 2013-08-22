require 'spec_helper'

describe Must, "struct" do
  let(:obj) { {"xyz" => ["a","b"] } }

  def ok(type) obj.must.struct?(type) == true ; end
  def ng(type) obj.must.struct?(type) == false; end

  ######################################################################
  ### error message

  describe "#struct" do
    subject { lambda { obj.must.struct({String => [Hash]}) } }

    it { should raise_error(Must::StructMismatch) }
    it { should raise_error(/\{String=>\[Hash\]\}/) }
  end

  ######################################################################
  ### basic object

  describe "basic object" do
    context "[]" do
      let(:obj) { [] }
      specify do
        ok []
        ng({})
      end
    end

    context "1" do
      let(:obj) { 1 }
      specify do
        ok Integer
        ok Fixnum
        ok 2
        ng String
      end
    end

    context "Fixnum" do
      let(:obj) { Fixnum }
      specify do
        ok Fixnum
        ok 2
      end
    end

    context "Integer" do
      let(:obj) { Integer }
      specify do
        ng Fixnum
      end
    end
  end

  describe "composite object" do
    context "(simple hash)" do
      let(:obj) { {"foo" => 1} }

      specify do
        ok String => Integer
        ng String
        ng Array
        ng [String]
        ng String => String
      end
    end

    context "([Hash])" do
      let(:obj) { [{:a=>1}, {:a=>3}] }

      specify do
        ok [Hash]
        ng [Array]
      end
    end

    context "(Hash(String, Array(Hash)))" do
      let(:obj) { {"foo" => [{:a=>1}, {:a=>3}]} }

      specify do
        ok Hash
        ng Array
        ok String => Array
        ng Array => Array
        ok String => [Hash]
      end
    end


    context "(Hash(String, Array(Hash)))" do
      let(:obj) { {"foo" => [{:a=>1}, {:a=>3}]} }

      specify do
        ok String => []
        ok String => Array
        ng String => Hash
        ok String => [Hash]

        ok String => Array(Hash)
        ng String => [Array]
        ng String => Array(String)
      end
    end

    context "(accept {String => [Hash]})" do
      def ok(obj); obj.must.struct?({String => [Hash]}).should == true ; end
      def ng(obj); obj.must.struct?({String => [Hash]}).should == false; end

      specify do
        ok({})
        ng []
        ok "foo" => []
        ng "foo" => {"gp"=>"-1"}
        ok "foo" => [{"gp"=>"-1"}]
        ok "foo" => [{"sid"=>"45064"}, {"gp"=>"-1"}]
        ng "foo" => [[{"sid"=>"45064"}]]
      end
    end
  end
end
