require 'test/unit'
require 'rubygems'
require File.join(File.dirname(__FILE__), '../init')

class StructTest < Test::Unit::TestCase
  def test_struct_test_successed
    assert_equal true, [].must.struct?([])
    assert_equal true, 1.must.struct?(Integer)
    assert_equal true, 1.must.struct?(Fixnum)
    assert_equal true, 1.must.struct?(2)
    assert_equal true, Fixnum.must.struct?(Fixnum)
    assert_equal true, Fixnum.must.struct?(2)

    obj = {"foo" => 1}
    assert_equal true, obj.must.struct?({String => Integer})

    obj = {"foo" => [{:a=>1}, {:a=>3}]}
    assert_equal true, obj.must.struct?(Hash)
    assert_equal true, obj.must.struct?({String => Array})
    assert_equal true, obj.must.struct?({String => [Hash]})
  end

  def test_struct_test_failed
    assert_equal false, [].must.struct?({})
    assert_equal false, Integer.must.struct?(Fixnum)

    obj = {"foo" => 1}
    assert_equal false, obj.must.struct?(String)
    assert_equal false, obj.must.struct?(Array)
    assert_equal false, obj.must.struct?([String])
    assert_equal false, obj.must.struct?({String => String})

    obj = [{:a=>1}, {:a=>3}]
    assert_equal false, obj.must.struct?([Array])

    obj = {"foo" => [{:a=>1}, {:a=>3}]}
    assert_equal false, obj.must.struct?({String => Hash})
    assert_equal false, obj.must.struct?({String => [Array]})
  end

  def test_struct_complicated
    def ok(obj)
      assert_equal obj, obj.must.struct({String => [Hash]})
    end
    def ng(obj)
      assert_raises(Invalid){ obj.must.struct({String => [Hash]})}
    end

    ok({})
    ng []
    ok "foo" => []
    ng "foo" => {"gp"=>"-1"}
    ok "foo" => [{"gp"=>"-1"}]
    ok "foo" => [{"sid"=>"45064"}, {"gp"=>"-1"}]
    ng "foo" => [[{"sid"=>"45064"}]]
  end
end
