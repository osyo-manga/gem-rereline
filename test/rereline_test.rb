# frozen_string_literal: true

require "test_helper"

class RerelineTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Rereline.const_defined?(:VERSION)
    end
  end
end
