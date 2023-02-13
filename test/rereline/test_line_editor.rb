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
    assert_equal("àÅ", editor.backward_text)

    editor.input_char("a")
    editor.input_char("ご")
    assert_equal("àÅaごがçä", editor.input_text)
    assert_equal("àÅaご", editor.backward_text)

    (1..100).each { editor.move_right }
    assert_equal(7, editor.input_pos)
  end

  def test_input_char_count
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = "abcàÅがçäあæ⛄🗻"
    }

    assert_equal(12, editor.input_char_count)
  end

  def test_backward_text
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = "がぎぐげご"
    }

    editor.input_pos = 0
    assert_equal("", editor.backward_text)

    editor.input_pos = 1
    assert_equal("が", editor.backward_text)

    editor.input_pos = 2
    assert_equal("がぎ", editor.backward_text)

    editor.input_pos = 100
    assert_equal("がぎぐげご", editor.backward_text)
  end

  def test_forward_text
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = "がぎぐげご"
    }

    editor.input_pos = 0
    assert_equal("がぎぐげご", editor.forward_text)

    editor.input_pos = 1
    assert_equal("ぎぐげご", editor.forward_text)

    editor.input_pos = 2
    assert_equal("ぐげご", editor.forward_text)

    editor.input_pos = 100
    assert_equal("", editor.forward_text)
  end

  def test_delete_backward_text
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = " がぎ ab ぐげご"
      editor.input_pos = 8
    }
    assert_equal("がぎ", editor.delete_backward_text(/\S+/))
    assert_equal("  ab ぐげご", editor.input_text)
    assert_equal(6, editor.input_pos)

    assert_equal(nil, editor.delete_backward_text(/not match/))
    assert_equal("  ab ぐげご", editor.input_text)
    assert_equal(6, editor.input_pos)
  end

  def test_jump_backward_pos
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = "がぎab 23 ぐ 345foo 6 @@"
      editor.input_pos = 18
    }

    editor.jump_backward_pos(/@/)
    assert_equal("がぎab 23 ぐ 345foo 6", editor.backward_text)
    assert_equal(18, editor.input_pos)

    editor.jump_backward_pos(/\d/)
    assert_equal("がぎab 23 ぐ 345foo ", editor.backward_text)
    assert_equal(17, editor.input_pos)

    editor.jump_backward_pos(/\d{2}/)
    assert_equal("がぎab 23 ぐ 3", editor.backward_text)
    assert_equal(11, editor.input_pos)

    editor.jump_backward_pos(/\s/)
    assert_equal("がぎab 23 ぐ", editor.backward_text)
    assert_equal(9, editor.input_pos)

    editor.jump_backward_pos(/ab/)
    assert_equal("がぎ", editor.backward_text)
    assert_equal(2, editor.input_pos)

    editor.jump_backward_pos(/no match/)
    assert_equal("がぎ", editor.backward_text)
    assert_equal(2, editor.input_pos)
  end

  def test_jump_forward_pos
    editor = Rereline::LineEditor.new { |editor|
      editor.input_text = "がぎ ぐげ ご 12 aa 34 ご"
      editor.input_pos = 3
    }

    editor.jump_forward_pos(/ぎ/)
    assert_equal("ぐげ ご 12 aa 34 ご", editor.forward_text)
    assert_equal(3, editor.input_pos)

    editor.jump_forward_pos(/ご/)
    assert_equal("ご 12 aa 34 ご", editor.forward_text)
    assert_equal(6, editor.input_pos)

    editor.jump_forward_pos(/\d{2}/)
    assert_equal("12 aa 34 ご", editor.forward_text)
    assert_equal(8, editor.input_pos)

    editor.jump_forward_pos(/aa/)
    assert_equal("aa 34 ご", editor.forward_text)
    assert_equal(11, editor.input_pos)
  end
end
