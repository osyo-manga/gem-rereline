# frozen_string_literal: true

require_relative "../test_helper.rb"

class Rereline::KeyStroke::Test < Test::Unit::TestCase
  class Rereline::KeyStroke::Ex::Test < Test::Unit::TestCase
    using Rereline::KeyStroke::Ex

    def test_start_with
      assert_equal(true,  [1, 2, 3].start_with?([1]))
      assert_equal(false, [1, 2, 3].start_with?([2]))
      assert_equal(true,  [1, 2, 3].start_with?([1, 2]))
      assert_equal(false, [1, 2, 3].start_with?([2, 2]))
      assert_equal(true,  [1, 2, 3].start_with?([1, 2, 3]))
      assert_equal(false, [1, 2, 3].start_with?([1, 2, 4]))
      assert_equal(false, [1, 2, 3].start_with?([1, 2, 3, 4]))
    end
  end

  def test_expand
    mapping = {
      [1]    => [:a],
      [2]    => [:b],
      [3, 4] => [:c],
      [5]    => [:d],
      [5, 1] => [:e],
      [5, 1, 2] => [:f],
    }
    stroke = Rereline::KeyStroke.new(mapping)

    assert_equal([[:a], []], stroke.expand([1]))
    assert_equal([[:b], []], stroke.expand([2]))
    assert_equal([[:a, :b], []], stroke.expand([1, 2]))

    assert_equal([[10, :b], []], stroke.expand([10, 2]))
    assert_equal([[:a, 10], []], stroke.expand([1, 10]))
    assert_equal([[], [3]], stroke.expand([3]))
    assert_equal([[:a, 10], [3]], stroke.expand([1, 10, 3]))
    assert_equal([[:a, 10, :c], []], stroke.expand([1, 10, 3, 4]))

    assert_equal([[], [5]], stroke.expand([5]))
    assert_equal([[], [5, 1]], stroke.expand([5, 1]))
    assert_equal([[:e, 10], []], stroke.expand([5, 1, 10]))
    assert_equal([[:f], []], stroke.expand([5, 1, 2]))
    assert_equal([[10, :c], [5, 1]], stroke.expand([10, 3, 4, 5, 1]))


    assert_equal([[:a, 10, :b, 10, 11, :e, 10, :a], [5]], stroke.expand([1, 10, 2, 10, 11, 5, 1, 10, 1, 5]))

    assert_equal([[:e], []], stroke.expand([5, 1], wait_match: false))
  end

  def test_expand_with_nexted
    mapping = {
      [1]    => [10],
      [2]    => [20],
      [3]    => [30],
      [4]    => [40],
      [4, 5] => [1],
      [20]   => [1, 3],
      [6]    => [4],
      [7]    => [2]
    }
    stroke = Rereline::KeyStroke.new(mapping)

    assert_equal([[10], []], stroke.expand([1]))
    assert_equal([[100, 10], []], stroke.expand([100, 1]))
    assert_equal([[10, 30], []], stroke.expand([2]))
    assert_equal([[10, 30], []], stroke.expand([7]))
    assert_equal([[10, 30, 30], []], stroke.expand([2, 3]))
    assert_equal([[10, 10], []], stroke.expand([4, 5, 4, 5]))
    assert_equal([[], [4]], stroke.expand([6]))
    assert_equal([[40, 100], []], stroke.expand([6, 100]))

    assert_equal([[10, 10, 30, 30], [4]], stroke.expand([1, 2, 3, 4]))

    assert_equal([[40], []], stroke.expand([4], wait_match: false))

    assert_equal([[40, 10], []], stroke.expand([6, 1]))
    assert_equal([[40, 40, 10], [4]], stroke.expand([4, 6, 1, 4]))
  end
end

