module Rereline
  class KeyActor
    class InsertChar
      include KeyActor::Callback

      attr_reader :editor

      def initialize(editor)
        @editor = editor
      end

      def on_key(key)
        case key
        when :CR
          raise Terminal::Finish.new(editor.input_text)
        end
      end
    end
  end
end
