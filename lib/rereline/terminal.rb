require "reline"
require_relative "./debugger.rb"
require_relative "./line_editor.rb"
require_relative "./key_stroke.rb"
require_relative "./key_actor.rb"


module Rereline
  using Debugger::Refine

  class Terminal
    class Finish < StandardError; end

    module Ex
      refine String do
        def displaywidth
          Reline::Unicode.calculate_width(self)
        end
      end
    end
    using Ex

    attr_reader :editor, :key_actor, :key_stroke, :input, :output

    def initialize(prompt, use_history)
      @editor = LineEditor.new do |editor|
        editor.prompt = prompt
      end
      @key_stroke = KeyStroke.new(KeyActor::MAPPING)
      @key_actor = KeyActor.new(editor)
      @input = $stdin
      @output = $stdout
      @input_key_buffer = []
    end

    def readline
      renader_editor
      loop do
        input_key(getkey)
      end
    rescue Finish => e
      output.write "\n"
      e.message
    end

    private

    def input_key(key)
      return if key.nil?

      @input_key_buffer << key
      extended_keys, matching_keys = key_stroke.expand(@input_key_buffer)

      @input_key_buffer = matching_keys
      extended_keys.each { |it|
        editor.input_key(key_actor.call(it))
      }
      renader_editor
    end

    def renader_editor
      # Move cursor to left edge
      output.write "\e[#{0 + 1}G"
      output.write editor.line
      # Delete characters to right of cursor position (end of text)
      output.write "\e[K"
      # Adjust cursor position
      output.write "\e[#{editor.prev_input_pos_line.displaywidth + 1}G"
    end

    def getkey
      c = input.raw(intr: true) { input.wait_readable(0.1) && input.getbyte }
      (c == 0x16 && input.raw(min: 0, time: 0, &:getbyte)) || c
    end
  end
end
