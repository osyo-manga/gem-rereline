# frozen_string_literal: true

require "stringio"
require_relative "../test_helper.rb"

class Rereline::Terminal::Test < Test::Unit::TestCase
  RIGHT_KEY = "\e[C"
  LEFT_KEY = "\e[D"
  HOME_KEY = "\e[H"
  END_KEY = "\e[F"
  DEL_KEY = "\e[3~"
  CR_KEY = "\r"

  CTRL_W_KEY = "\x17"
  BACKSPACE_KEY = "\x7F"

  def assert_terminal_input_text(expected, input)
    terminal = Rereline::Terminal.new("", false)
    terminal.send(:input_text, input)
    assert_equal(expected, terminal.editor.input_text)
  end

  def assert_terminal_input_pos(expected, input)
    terminal = Rereline::Terminal.new("", false)
    terminal.send(:input_text, input)
    assert_equal(expected, terminal.editor.input_pos)
  end

  def assert_terminal_output(expected, input, prompt: "")
    output = StringIO.new
    terminal = Rereline::Terminal.new(prompt, false) { |it| it.output = output }
    input.bytes.each { |it| terminal.send(:input_key, it) }
    terminal.send(:renader_editor)
    assert_equal(expected, output.string)
  end

  def test_input_text
    assert_terminal_input_text("abc", "abc")
    assert_terminal_input_text("あいうえ", "あいうえ")
    assert_terminal_output("\e[1Gあいうえ\e[K\e[9G", "あいうえ")
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

  def test_input_with_home_end
    # with combining characters
    input = "がぎぐ#{HOME_KEY}げ#{HOME_KEY}#{END_KEY}ご"
    assert_terminal_input_text("げがぎぐご", input)
    assert_terminal_input_pos(5, input)
  end

  def test_input_with_backspace
    # with combining characters
    input = "がぎぐ#{BACKSPACE_KEY}#{BACKSPACE_KEY}げご#{BACKSPACE_KEY}"
    assert_terminal_input_text("がげ", input)
    assert_terminal_input_pos(2, input)
  end

  def test_input_ctrl_char
    input = "がぎ ぐ  #{CTRL_W_KEY} げご  #{CTRL_W_KEY}"
    assert_terminal_input_text("がぎ  ", input)
    assert_terminal_input_pos(4, input)

    input = "がぎぐげご#{DEL_KEY}#{LEFT_KEY}#{DEL_KEY}"
    assert_terminal_input_text("がぎぐげ", input)
    assert_terminal_input_pos(4, input)
  end

  def test_input_CR
    input = "がぎぐげご#{CR_KEY}"
    terminal = Rereline::Terminal.new("", false)

    assert_raise(Rereline::Terminal::Finish, "がぎぐげご") {
      terminal.send(:input_text, input)
    }
  end

  def test_input_text_with_prompt
    assert_terminal_output("\e[1Gprompt >あいうえ\e[K\e[17G", "あいうえ", prompt: "prompt >")
    assert_terminal_output("\e[1Gげご >がぎぐ\e[K\e[13G", "がぎぐ", prompt: "げご >")
  end
end
