require_relative "./key_actor/move_cursor.rb"

module Rereline
  class KeyActor
    MAPPING = {
      [127] => [:BS],
      [13]  => [:CR],
      [27, 91, 67]  => [:RIGHT],
      [27, 91, 68]  => [:LEFT],
      [27, 91, 70]  => [:END],
      [27, 91, 72]  => [:HOME]
    }

    attr_reader :editor, :actors

    def initialize(editor)
      @editor = editor
      @actors = [
        MoveCursor.new(editor)
      ]
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

    def editor_ctrl(key)
      case key
      when :CR
        raise Terminal::Finish.new(editor.input_text)
      when :BS
        editor.delete_prev_input_pos
      else
        actors.each { |actor|
          actor.call(key)
        }
      end
    end
  end
end
