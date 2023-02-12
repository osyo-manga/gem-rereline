module Rereline
  class KeyActor
    class DeleteText
      attr_reader :editor

      def initialize(editor)
        @editor = editor
      end

      def call(key)
        case key
        when :BS
          editor.delete_prev_input_pos
        end
      end
    end
  end
end
