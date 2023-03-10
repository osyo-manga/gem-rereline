module Rereline
  class KeyActor
    class MoveCursor
      include KeyActor::Callback

      attr_reader :editor

      def initialize(editor)
        @editor = editor
      end

      def on_key(key)
        case key
        when :LEFT
          editor.move_left
        when :RIGHT
          editor.move_right
        when :END
          editor.input_pos = editor.input_char_count
        when :HOME
          editor.input_pos = 0
        end
      end
    end
  end
end
