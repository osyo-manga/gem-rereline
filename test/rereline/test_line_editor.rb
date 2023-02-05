# frozen_string_literal: true

require_relative "../test_helper.rb"

class Rereline::KeyStroke::Test < Test::Unit::TestCase
  def test_input_pos_assign
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = "hogefoo"
      editor.input_pos = 4
    }

    editor.input_pos = 7
    assert_equal(7, editor.input_pos)

    editor.input_pos = 0
    assert_equal(0, editor.input_pos)

    editor.input_pos = 8
    assert_equal(7, editor.input_pos)

    editor.input_pos = -1
    assert_equal(0, editor.input_pos)
  end

  def test_move_pos
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = "hogefoo"
      editor.input_pos = 4
    }

    editor.move_left
    assert_equal(3, editor.input_pos)

    editor.move_right
    assert_equal(4, editor.input_pos)

    (1..10).each { editor.move_right }
    assert_equal(7, editor.input_pos)

    (1..10).each { editor.move_left }
    assert_equal(0, editor.input_pos)

    editor.move_input_pos(5)
    assert_equal(5, editor.input_pos)

    editor.move_input_pos(-2)
    assert_equal(3, editor.input_pos)

    editor.move_input_pos(100)
    assert_equal(7, editor.input_pos)

    editor.move_input_pos(-100)
    assert_equal(0, editor.input_pos)
  end

  def test_delete_prev_input_pos
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = "hogefoo"
      editor.input_pos = 4
    }

    editor.delete_prev_input_pos
    assert_equal(3, editor.input_pos)
    assert_equal("hogfoo", editor.input_text)

    editor.delete_prev_input_pos
    assert_equal(2, editor.input_pos)
    assert_equal("hofoo", editor.input_text)

    editor.input_pos = 0
    editor.delete_prev_input_pos
    editor.delete_prev_input_pos
    assert_equal(0, editor.input_pos)
    assert_equal("hofoo", editor.input_text)
  end

  def test_special_char
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = "あæ🗻"
      editor.input_pos = 2
    }

    editor.input_char("⛄")
    assert_equal(3, editor.input_pos)
    assert_equal("あæ⛄🗻", editor.input_text)

    editor.move_left
    editor.delete_prev_input_pos
    assert_equal(1, editor.input_pos)
    assert_equal("あ⛄🗻", editor.input_text)

    editor.move_right
    editor.delete_prev_input_pos
    assert_equal(1, editor.input_pos)
    assert_equal("あ🗻", editor.input_text)
  end

  def test_combining_character
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = "àÅがçä"
      editor.input_pos = 0
    }

    editor.move_right
    editor.move_right
    assert_equal("àÅ", editor.prev_input_pos_line)

    editor.input_char("a")
    editor.input_char("ご")
    assert_equal("àÅaごがçä", editor.input_text)
    assert_equal("àÅaご", editor.prev_input_pos_line)

    (1..100).each { editor.move_right }
    assert_equal(7, editor.input_pos)
  end
end
