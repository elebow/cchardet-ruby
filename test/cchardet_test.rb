# frozen_string_literal: true

require "test_helper"

class CChardetTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CChardet::VERSION
  end

  def test_it_does_something_useful
    assert_equal({ encoding: "UTF-8" }, CChardet.detect("♥".encode("UTF-8")))
  end
end
