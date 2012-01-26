require 'test/unit'
require 'rubygems'
require File.join(File.dirname(__FILE__), '../init')

class MatchTest < Test::Unit::TestCase
  def test_match_range
    # succeeded
    assert_equal 1, 1.must.match(0..3)
    assert_equal 'b', 'b'.must.match('a'..'c')

    # failed
    assert_raises(Invalid) { 1.must.match(2..3) }
    assert_raises(Invalid) { 'a'.must.match('y'..'z') }
  end
end
