module Rereline
  class KeyActor
    class DeleteText
      attr_reader :editor

      def initialize(editor)
        @editor = editor
      end

      def call(key)
        case key
        when :DEL
          editor.delete_prev_input_pos
        when :ETB
          editor.delete_backward_text(/\S*\s*$/)
        end
      end
    end
  end
end
