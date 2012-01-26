require 'test/unit'
require 'rubygems'
require File.join(File.dirname(__FILE__), '../init')

class DuckTest < Test::Unit::TestCase
  class ClassFoo
    def foo; 1; end
  end

  module ModuleFoo
    def foo; 1; end
  end

  def test_itself_duck_type
    # succeeded
    assert_equal 1, 1.must.duck(:to_s)
    assert_equal 1, 1.must.duck("to_s")
    assert_equal 1, 1.must.duck(".to_s")
    assert_equal ClassFoo, ClassFoo.must.duck(:to_s)
    assert_equal ClassFoo, ClassFoo.must.duck("to_s")
    assert_equal ClassFoo, ClassFoo.must.duck(".to_s")
    assert_equal ModuleFoo, ModuleFoo.must.duck(:to_s)
    assert_equal ModuleFoo, ModuleFoo.must.duck("to_s")
    assert_equal ModuleFoo, ModuleFoo.must.duck(".to_s")

    # failed
    assert_raises(Invalid) { 1.must.duck(:foo) }
    assert_raises(Invalid) { 1.must.duck("foo") }
    assert_raises(Invalid) { 1.must.duck(".foo") }
    assert_raises(Invalid) { ClassFoo.must.duck(:foo) }
    assert_raises(Invalid) { ClassFoo.must.duck("foo") }
    assert_raises(Invalid) { ClassFoo.must.duck(".foo") }
    assert_raises(Invalid) { ModuleFoo.must.duck(:foo) }
    assert_raises(Invalid) { ModuleFoo.must.duck("foo") }
    assert_raises(Invalid) { ModuleFoo.must.duck(".foo") }
  end

  def test_instance_duck_type
    # succeeded
    assert_equal ClassFoo, ClassFoo.must.duck("#foo")
    assert_equal ModuleFoo, ModuleFoo.must.duck("#foo")

    # failed
    assert_raises(Invalid) { 1.must.duck("#bar") } # instance object
    assert_raises(Invalid) { ClassFoo.must.duck("#bar") }
    assert_raises(Invalid) { ModuleFoo.must.duck("#bar") }
  end

  def test_itself_duck_test
    # succeeded
    assert_equal true, 1.must.duck?(:to_s)
    assert_equal true, 1.must.duck?("to_s")
    assert_equal true, 1.must.duck?(".to_s")
    assert_equal true, ClassFoo.must.duck?(:to_s)
    assert_equal true, ClassFoo.must.duck?("to_s")
    assert_equal true, ClassFoo.must.duck?(".to_s")
    assert_equal true, ModuleFoo.must.duck?(:to_s)
    assert_equal true, ModuleFoo.must.duck?("to_s")
    assert_equal true, ModuleFoo.must.duck?(".to_s")

    # failed
    assert_equal false, 1.must.duck?(:foo)
    assert_equal false, 1.must.duck?("foo")
    assert_equal false, 1.must.duck?(".foo")
    assert_equal false, ClassFoo.must.duck?(:foo)
    assert_equal false, ClassFoo.must.duck?("foo")
    assert_equal false, ClassFoo.must.duck?(".foo")
    assert_equal false, ModuleFoo.must.duck?(:foo)
    assert_equal false, ModuleFoo.must.duck?("foo")
    assert_equal false, ModuleFoo.must.duck?(".foo")
  end

  def test_instance_duck_test
    # succeeded
    assert_equal true, ClassFoo.must.duck?("#foo")
    assert_equal true, ModuleFoo.must.duck?("#foo")

    # failed
    assert_equal false, 1.must.duck?("#bar") # instance object
    assert_equal false, ClassFoo.must.duck?("#bar")
    assert_equal false, ModuleFoo.must.duck?("#bar")
  end
end
