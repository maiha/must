require 'spec_helper'

describe Must do
  let(:obj) { {"xyz" => ["a","b"] } }

  subject { lambda { obj.must.struct({String => [Hash]}) } }

  it { should raise_error(Must::StructMismatch) }
  it { should raise_error(/\{String=>\[Hash\]\}/) }
end
