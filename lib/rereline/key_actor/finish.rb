module Rereline
  class KeyActor
    class Finish
      include KeyActor::Callback

      attr_reader :editor

      def initialize(editor)
        @editor = editor
      end

      def on_char(char)
        editor.input_byte(char)
      end
    end
  end
end
