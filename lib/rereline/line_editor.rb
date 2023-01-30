module Rereline
  class LineEditor
    attr_accessor :prompt, :encoding
    attr_reader :input_text, :input_pos

    def initialize(&block)
      @input_text = ""
      @encoding = Encoding.default_external
      block.call(self) if block
      @input_key_buffer = []
      @input_pos = 0
    end

    def input_key(key)
      return if key.nil?

      @input_key_buffer << key
      if (result = @input_key_buffer.map { _1.chr }.join.force_encoding(encoding)).valid_encoding?
        input_char(result)
        @input_key_buffer.clear
      end
    end

    def input_char(c)
      input_text.insert(input_pos, c)
      @input_pos += 1
    end

    def delete_prev_input_pos
      input_text.slice!(-1)
      @input_pos -= 1
    end

    def move_input_pos(offset)
      @input_pos = (input_pos + offset).clamp(0, input_text.size)
    end

    def move_left
      move_input_pos(-1)
    end

    def move_right
      move_input_pos(+1)
    end

    def prev_input_pos_line
      "#{prompt}#{input_text.slice(0, input_pos)}"
    end

    def line
      "#{prompt}#{input_text}"
    end
  end
end
