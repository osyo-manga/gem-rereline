# frozen_string_literal: true

require "stringio"
require_relative "../test_helper.rb"

class Rereline::Terminal::Test < Test::Unit::TestCase
  RIGHT_KEY = "\e[C"
  LEFT_KEY = "\e[D"
  BACKSPACE_KEY = "\x7F"

  def assert_terminal_input_text(expected, input)
    terminal = Rereline::Terminal.new("", false)
    input.bytes.each { terminal.send(:input_key, _1) }
    assert_equal(expected, terminal.editor.input_text)
  end

  def assert_terminal_input_pos(expected, input)
    terminal = Rereline::Terminal.new("", false)
    input.bytes.each { terminal.send(:input_key, _1) }
    assert_equal(expected, terminal.editor.input_pos)
  end

  def test_input_text
    assert_terminal_input_text("abc", "abc")
    assert_terminal_input_text("あいうえ", "あいうえ")
  end

  def test_input_text_with_combining_character
    # combining characters
    assert_terminal_input_text("がぎぐげご", "がぎぐげご")
  end

  def test_input_pos
    assert_terminal_input_pos(3, "abc")
    assert_terminal_input_pos(4, "あいうえ")
  end

  def test_input_pos_with_combining_character
    # combining characters
    assert_terminal_input_pos(5, "がぎぐげご")
  end

  def test_input_with_cursor
    # with combining characters
    input = "がぎぐ#{LEFT_KEY}#{LEFT_KEY}#{RIGHT_KEY}げ#{LEFT_KEY}ご#{LEFT_KEY}"
    assert_terminal_input_text("がぎげごぐ", input)
    assert_terminal_input_pos(4, input)
  end

  def test_input_with_backspace
    # with combining characters
    input = "がぎぐ#{BACKSPACE_KEY}#{BACKSPACE_KEY}げご#{BACKSPACE_KEY}"
    assert_terminal_input_text("がげ", input)
    assert_terminal_input_pos(2, input)
  end
end
