require 'test/unit'
require 'rubygems'
require File.join(File.dirname(__FILE__), '../init')

class StructInfoTest < Test::Unit::TestCase
  ######################################################################
  ### same?

  def test_same_p
    assert   Must::StructInfo.new(1).same?(Integer)
    assert   Must::StructInfo.new(1).same?(Numeric)
    assert ! Must::StructInfo.new(1).same?(String)

    assert   Must::StructInfo.new(Integer).same?(Integer)
    assert   Must::StructInfo.new(Integer).same?(Numeric)
    assert   Must::StructInfo.new(Fixnum).same?(1)
  end

  ######################################################################
  ### types

  def test_types
    assert_equal [Fixnum], Must::StructInfo.new(1).types
    assert_equal [Hash, Symbol, String, Float],
                 Must::StructInfo.new({:a=>{"1"=>0.25}}).types
  end

end
