require 'test/unit'
require 'rubygems'
require File.join(File.dirname(__FILE__), '../init')

class StructTest < Test::Unit::TestCase
  def test_struct_basic_object
    assert   [].must.struct?([])
    assert ! [].must.struct?({})

    assert   1.must.struct?(Integer)
    assert   1.must.struct?(Fixnum)
    assert   1.must.struct?(2)
    assert ! 1.must.struct?(String)
    assert   Fixnum.must.struct?(Fixnum)
    assert   Fixnum.must.struct?(2)
    assert ! Integer.must.struct?(Fixnum)
  end

  def test_struct_composite_objects
    obj = {"foo" => 1}
    assert   obj.must.struct?({String => Integer})
    assert ! obj.must.struct?(String)
    assert ! obj.must.struct?(Array)
    assert ! obj.must.struct?([String])
    assert ! obj.must.struct?({String => String})

    obj = [{:a=>1}, {:a=>3}]
    assert   obj.must.struct?([Hash])
    assert ! obj.must.struct?([Array])

    obj = {"foo" => [{:a=>1}, {:a=>3}]}
    assert   obj.must.struct?(Hash)
    assert ! obj.must.struct?(Array)
    assert   obj.must.struct?({String => Array})
    assert ! obj.must.struct?({Array => Array})
    assert   obj.must.struct?({String => [Hash]})

    obj = {"foo" => [{:a=>1}, {:a=>3}]}
    assert   obj.must.struct?({String => []})
    assert   obj.must.struct?({String => Array})
    assert ! obj.must.struct?({String => Hash})
    assert   obj.must.struct?({String => [Hash]})
    assert   obj.must.struct?({String => Array(Hash)})
    assert ! obj.must.struct?({String => [Array]})
    assert ! obj.must.struct?({String => Array(String)})
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
