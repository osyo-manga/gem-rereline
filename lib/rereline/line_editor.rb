require_relative "./debugger.rb"
require_relative "./refine/string.rb"

module Rereline
  class LineEditor
    using Debugger::Refine
    using Rereline::Refine::String

    attr_accessor :encoding, :input_text
    attr_reader :input_pos

    def initialize(&block)
      @input_text = ""
      @input_pos = 0
      @encoding = Encoding.default_external
      block.call(self) if block
      @input_text = @input_text.dup
      @input_byte_buffer = []
    end

    def input_byte(key)
      return if key.nil?

      @input_byte_buffer << key
      if (result = @input_byte_buffer.map(&:chr).join.force_encoding(encoding)).valid_encoding?
        input_char(result)
        @input_byte_buffer.clear
      end
    end

    def input_char(c)
      input_text.grapheme_cluster_insert(input_pos, c)
      move_right
    end

    def input_char_count
      input_text.grapheme_clusters.count
    end

    def move_input_pos(offset)
      self.input_pos = input_pos + offset
    end

    def move_left
      move_input_pos(-1)
    end

    def move_right
      move_input_pos(+1)
    end

    def input_pos=(pos)
      @input_pos = pos.clamp(0, input_char_count)
    end

    def backward_text
      input_text.grapheme_cluster_slice(0...input_pos)
    end

    def forward_text
      input_text.grapheme_cluster_slice(input_pos..)
    end

    def delete_prev_input_pos
      return if input_pos <= 0
      input_text.grapheme_cluster_slice!(input_pos - 1, 1)
      move_left
    end

    def delete_backward_text(reg)
      input_text.replace "#{backward_text.sub(/(#{reg})$/, "")}#{forward_text}"
      $1.tap { |it| move_input_pos(it.grapheme_clusters.count) }
    end

    def jump_backward_pos(reg)
      pos = backward_text.last_match(reg).to_a[1]&.grapheme_clusters&.count || input_pos
      self.input_pos = pos
    end

    def jump_forward_pos(reg)
      pos = forward_text.match(/(.*?)#{reg}/).to_a[1]&.grapheme_clusters&.count || 0
      self.input_pos = input_pos + pos
    end
  end
end
