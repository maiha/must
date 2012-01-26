require 'test/unit'
require 'rubygems'
require File.join(File.dirname(__FILE__), '../init')

class MustTest < Test::Unit::TestCase

  def test_must_be
    assert_nothing_raised {1.must.be 1}
    assert_nothing_raised {[1,2,3].must.be [1,2,3]}
    assert_nothing_raised {{:a=>1, "b"=>2}.must.be({:a=>1, "b"=>2})}
    assert_nothing_raised {String.must.be String}
  end

  def test_must_be_error
    assert_raises(Invalid) {1.must.be 2}
  end

  def test_must_be_with_block
    assert_equal :error, 1.must.be(2) {:error}
  end

  def test_must_not_be_blank
    if Object.instance_methods.include?("blank?")
      assert_equal "ok", "ok".must.not.be.blank
      assert_equal "ok", "ok".must.not.be.blank {"ng"}
      assert_equal "ng",   "".must.not.be.blank {"ng"}
      assert_raises(Invalid) {"".must.not.be.blank}
    end
  end

  def test_must_accepts_args_as_kind_of
    assert_equal "ok", "ok".must(String)
    assert_raises(Invalid) {"ok".must(Integer)}
    assert_equal "ok", "ok".must(Integer, String)
  end
end

