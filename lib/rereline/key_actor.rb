module Rereline
  class KeyActor
    MAPPING = {
      [127] => [:BS],
      [13]  => [:CR],
      [27, 91, 67]  => [:RIGHT],
      [27, 91, 68]  => [:LEFT]
    }

    attr_reader :editor

    def initialize(editor)
      @editor = editor
    end

    def call(input)
      case input
      when Symbol
        editor_ctrl(input) && nil
      else
        input
      end
    end

    private

    def editor_ctrl(input)
      case input
      when :CR
        raise Terminal::Finish.new(editor.input_text)
      when :BS
        editor.delete_prev_input_pos
      when :LEFT
        editor.move_left
      when :RIGHT
        editor.move_right
      end
    end
  end
end
