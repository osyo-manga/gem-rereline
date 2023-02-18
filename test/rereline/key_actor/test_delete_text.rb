# frozen_string_literal: true

require_relative "../../test_helper.rb"

class Rereline::KeyActor::DeleteText::Test < Rereline::TestCase::KeyActor
  # BackSpace
  def test_DEL
    assert_key_actor_input_text(" ご", :DEL, " ご ")
    assert_key_actor_input_pos(2, :DEL, " ご ")

    assert_key_actor_input_text(" ", :DEL, " ご")
    assert_key_actor_input_pos(1, :DEL, " ご")

    assert_key_actor_input_text(" ご", :DEL, " ご🗻")
  end

  # ^W
  def test_ETB
    assert_key_actor_input_text("  ", :ETB, "  ⛄🗻ご")
    assert_key_actor_input_pos(2, :ETB, "  ⛄🗻ご")

    assert_key_actor_input_text("  ご  ", :ETB, "  ご  🗻")
    assert_key_actor_input_pos(5, :ETB, "  ご  🗻")

    assert_key_actor_input_text(" ", :ETB, " ご  ")
    assert_key_actor_input_pos(1, :ETB, " ご  ")

    assert_key_actor_input_text("", :ETB, "  ")
    assert_key_actor_input_pos(0, :ETB, "  ")
  end

  # DEL key
  def test_DEK_KEY
    assert_key_actor_input_text("🗻ご", :DEL_KEY, "⛄🗻ご", 0)
    assert_key_actor_input_text("⛄ご", :DEL_KEY, "⛄🗻ご", 1)
    assert_key_actor_input_text("⛄🗻", :DEL_KEY, "⛄🗻ご", 2)
    assert_key_actor_input_text("⛄🗻ご", :DEL_KEY, "⛄🗻ご", 3)

    assert_key_actor_input_pos(0, :DEL_KEY, "⛄🗻ご", 0)
    assert_key_actor_input_pos(1, :DEL_KEY, "⛄🗻ご", 1)
    assert_key_actor_input_pos(2, :DEL_KEY, "⛄🗻ご", 2)
    assert_key_actor_input_pos(3, :DEL_KEY, "⛄🗻ご", 3)
  end
end
