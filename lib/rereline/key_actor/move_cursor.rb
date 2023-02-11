module Rereline
  class KeyActor
    class MoveCursor
      attr_reader :editor

      def initialize(editor)
        @editor = editor
      end

      def call(key)
        case key
        when :LEFT
          editor.move_left
        when :RIGHT
          editor.move_right
        end
      end
    end
  end
end
