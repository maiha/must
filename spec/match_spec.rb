require 'spec_helper'

describe Must::Rule, "match" do
  specify "[OK]" do
    1.must.match(0..3).should == 1
    'b'.must.match('a'..'c').should == 'b'
  end

  specify "[NG]" do
    lambda { 1.must.match(2..3) }.should raise_error(Must::Invalid)
    lambda { 'a'.must.match('y'..'z') }.should raise_error(Must::Invalid)
  end
end
