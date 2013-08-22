require 'spec_helper'

describe Must::Differ do
  let(:a) {}
  let(:b) {}
  let(:path) { "obj" }

  subject { lambda { Must::Differ.new(a, b, path).execute! } }

  context "(same class)" do
    context "(same objects)" do
      let(:a) { 1 }
      let(:b) { 1 }
      it { should_not raise_error }
    end

    context "(same values)" do
      let(:a) { [1] }
      let(:b) { [1] }
      it { should_not raise_error }
    end

    context "(different values)" do
      let(:a) { [1] }
      let(:b) { [2] }
      it { should raise_error(Must::ValueMismatch) }
    end

    context "(different hash)" do
      let(:a) { {
          "currency"=>"JPY",
          "strategy"=>"version_1",
        } }
      let(:b) { {
          "currency"=>"JPY",
          "strategy"=>"classic",
        } }
      it { should raise_error(Must::ValueMismatch) }
      it { should raise_error(/strategy/) }
    end
  end

  context "(same struct)" do
    context "(same objects)" do
      let(:x) { [ { "host" => "x" },  { "host" => "y" } ] }
      let(:a) { x }
      let(:b) { x }
      it { should_not raise_error }
    end

    context "(same values)" do
      let(:a) { [ { "host" => "x" },  { "host" => "y" } ] }
      let(:b) { [ { "host" => "x" },  { "host" => "y" } ] }
      it { should_not raise_error }
    end

    context "(different values)" do
      let(:a) { [ { "host" => "x" },  { "host" => "y" } ] }
      let(:b) { [ { "host" => "x" },  { "host" => "z" } ] }
      it { should raise_error(Must::ValueMismatch) }
    end

    context "(different struct)" do
      let(:a) { [ { "host" => "x" },  { "host" => "y" } ] }
      let(:b) { [ [ "host",   "x" ],  [ "host" ,  "y" ] ] }
      it { should raise_error(Must::StructMismatch) }
    end
  end

end
