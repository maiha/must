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
end


class CoercedTest < Test::Unit::TestCase
  def test_is_a_feature
    assert_equal 1, 1.must.be.coerced(Integer)
    assert_equal 1, 1.must.be.coerced(Integer, String)
    assert_equal 1, 1.must.be.coerced(String, Numeric)

    assert_raises(Invalid)     { "1".must.be.coerced(Integer) }
    assert_raises(Invalid)     { "1".must.be.coerced(Integer, Range) }
    assert_raises(NotImplementedError) { "1".must.be.coerced(Integer){raise NotImplementedError} }
  end

  def test_coecing_succeeded
    assert_equal 1,   1.must.be.coerced(Integer, String=>proc{|i|i.to_i})
    assert_equal 1, "1".must.be.coerced(Integer, String=>proc{|i|i.to_i})
    assert_equal 1, "1".must.be.coerced(Integer, String=>proc{|i|i.to_i}, Range=>proc{|i|i.first})
    assert_equal 1, "1".must.be.coerced(Integer, Range, String=>proc{|i|i.to_i}, Range=>proc{|i|i.first})
    assert_equal 1, "1".must.be.coerced(File, Integer, Range, String=>proc{|i|i.to_i}, Range=>proc{|i|i.first})
  end

  def test_coecing_failed
    assert_raises(Invalid)     { "1".must.be.coerced(Integer, String=>proc{|i| /a/}) }
    assert_raises(NotImplementedError) { "1".must.be.coerced(Integer, String=>proc{|i| /a/}){raise NotImplementedError} }
  end

  def test_cascaded_coecing_succeeded
    assert_equal 1,    1.must.be.coerced(Integer, Symbol=>:to_s, String=>:to_i)
    assert_equal 1,  "1".must.be.coerced(Integer, Symbol=>:to_s, String=>:to_i)
    assert_equal 1, :"1".must.be.coerced(Integer, Symbol=>:to_s, String=>:to_i)
  end

  def test_detect_livelock
    assert_raises(Invalid){ "1".must.be.coerced(Integer, Symbol=>:to_s, String=>:intern)}
    assert_raises(Invalid){:"1".must.be.coerced(Integer, Symbol=>:to_s, String=>:intern)}
  end

end
