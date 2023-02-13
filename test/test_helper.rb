# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "rereline"

require "test/unit"

class Rereline::TestCase
  class KeyActor < Test::Unit::TestCase
    def key_actor_class
      Object.const_get self.class.inspect.sub(/::[^:]+$/, "")
    end

    def build_actor(editor)
      key_actor_class.new(editor)
    end

    def build_editor(text)
      Rereline::LineEditor.new { |editor|
        editor.replace text
      }
    end

    def assert_key_actor_input_text(expected, text, key)
      editor = build_editor(text)
      actor = build_actor(editor)
      actor.call(key)
      assert_equal(expected, editor.input_text)
    end

    def assert_key_actor_input_pos(expected, text, key)
      editor = build_editor(text)
      actor = build_actor(editor)
      actor.call(key)
      assert_equal(expected, editor.input_pos)
    end
  end
end
