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
    assert_equal [Hash, Symbol, String, Float], Must::StructInfo.new({:a=>{"1"=>0.25}}).types
  end

  ######################################################################
  ### struct

  def test_compact
    assert_equal(Fixnum, Must::StructInfo.new(1).compact)
    assert_equal(Hash, Must::StructInfo.new({}).compact)
    assert_equal(Array, Must::StructInfo.new([]).compact)
    assert_equal([Fixnum], Must::StructInfo.new([1]).compact)
    assert_equal({String=>Fixnum}, Must::StructInfo.new({"a"=>1}).compact)
    assert_equal([{String=>Float}], Must::StructInfo.new([{"1"=>0.25}]).compact)
    assert_equal({String=>{String=>[{Symbol=>Fixnum}]}}, Must::StructInfo.new({"1.1" => {"jp"=>[{:a=>0},{:b=>2}]}}).compact)
  end

  def test_compact_array_into_first_element
    assert_equal [Fixnum], Must::StructInfo.new([1, "a"]).compact
    assert_equal [String], Must::StructInfo.new(["a", 1]).compact
  end

  ######################################################################
  ### pp

  def test_inspect
    assert_equal "Fixnum", Must::StructInfo.new(1).inspect
    assert_equal "Hash", Must::StructInfo.new({}).inspect
    assert_equal "Array", Must::StructInfo.new([]).inspect
    assert_equal "[Fixnum]", Must::StructInfo.new([1]).inspect
    assert_equal "{String=>Fixnum}", Must::StructInfo.new({"a"=>1}).inspect
    assert_equal "[{String=>Float}]", Must::StructInfo.new([{"1"=>0.25}]).inspect
    assert_equal "{String=>{String=>[{Symbol=>Fixnum}]}}", Must::StructInfo.new({"1.1" => {"jp"=>[{:a=>0},{:b=>2}]}}).inspect
  end
end
