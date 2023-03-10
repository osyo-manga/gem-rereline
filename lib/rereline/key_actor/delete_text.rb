module Rereline
  class KeyActor
    class DeleteText
      include KeyActor::Callback

      attr_reader :editor

      def initialize(editor)
        @editor = editor
      end

      def on_key(key)
        case key
        when :DEL
          editor.delete_prev_input_pos
        when :ETB
          editor.delete_backward_text(/\S*\s*$/)
        when :DEL_KEY
          if !editor.forward_text.empty?
            editor.move_right
            editor.delete_prev_input_pos
          end
        end
      end
    end
  end
end
