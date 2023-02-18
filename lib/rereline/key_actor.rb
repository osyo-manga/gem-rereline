require_relative "./key_actor/callback.rb"
require_relative "./key_actor/move_cursor.rb"
require_relative "./key_actor/delete_text.rb"
require_relative "./key_actor/insert_char.rb"
require_relative "./key_actor/finish.rb"

module Rereline
  class KeyActor
    MAPPING = {
      [13]  => [:CR],     # ^M
      [23]  => [:ETB],    # ^W
      [127] => [:DEL],    # ^? (BackSpace)
      [27, 91, 67]  => [:RIGHT],
      [27, 91, 68]  => [:LEFT],
      [27, 91, 70]  => [:END],
      [27, 91, 72]  => [:HOME],
      [27, 91, 51, 126]  => [:DEL_KEY]
    }

    attr_reader :editor, :actors

    def initialize(editor)
      @editor = editor
      @actors = [
        MoveCursor.new(editor),
        DeleteText.new(editor),
        InsertChar.new(editor),
        Finish.new(editor)
      ]
    end

    def call(input)
      actors.each { |actor|
        actor.call(input)
      }
    end
  end
end
