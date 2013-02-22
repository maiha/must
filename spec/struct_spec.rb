require 'spec_helper'

describe Must do
  let(:obj) { {"xyz" => ["a","b"] } }

  specify "show more info about struct differs" do
    lambda {
      obj.must.struct({String => [Hash]})
    }.should raise_error(/expected \{String=>\[Hash\]/)
  end
end
