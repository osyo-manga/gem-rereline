# frozen_string_literal: true

require_relative "./rereline/version"
require_relative "./rereline/terminal.rb"

module Rereline
  class Error < StandardError; end

  def self.readline(prompt, use_history = false)
    Terminal.new(prompt, use_history).readline
  end
end
