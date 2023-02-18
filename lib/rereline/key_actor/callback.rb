module Rereline
  class KeyActor
    module Callback
      def call(input)
        case input
        when Symbol
          on_key(input)
        else
          on_char(input)
        end
      end

      def on_key(key)
        # No implemented
      end

      def on_char(char)
        # No implemented
      end
    end
  end
end
