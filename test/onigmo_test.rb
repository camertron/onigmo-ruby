# frozen_string_literal: true

require "test_helper"

class OnigmoTest < Minitest::Test
  def test_search
    regexp = Onigmo::OnigRegexp.compile("[abc]")
    assert regexp.search("foo a zoo")
  end

  def test_match_data
    regexp = Onigmo::OnigRegexp.compile("[abc]")
    match_data = regexp.search("foo a zoo")

    assert_equal [[4, 5]], match_data.captures
    assert_equal 4, match_data.get_begin(0)
    assert_equal 5, match_data.get_end(0)
    assert_equal "a", match_data.match(0)
  end

  def test_bad_regexp
    error = assert_raises(RuntimeError) do
      Onigmo::OnigRegexp.compile("[abc")
    end

    assert_equal "premature end of char-class", error.message
  end

  def test_no_match
    regexp = Onigmo::OnigRegexp.compile("[abc]")
    match_data = regexp.search("foo")
    assert_nil match_data
  end
end
