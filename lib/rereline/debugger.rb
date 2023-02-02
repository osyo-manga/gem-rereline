# ENV["RELINE_STDERR_TTY"] = "/dev/pts/1"

module Rereline
  class Debugger
    def initialize(output)
      @output = output
    end

    def puts(*args)
      @output&.puts(*args)
    end

    def debug(*args, &block)
      if block
        node = RubyVM::AbstractSyntaxTree.of(block, keep_script_lines: true)
        code = node.children.last.source
        puts "#{code} => #{block.binding.eval(code).inspect}"
      else
        puts(*args)
      end
    end

    module Refine
      refine Kernel do
        output = if ENV['RELINE_STDERR_TTY']
                   File.open(ENV['RELINE_STDERR_TTY'], 'a')
                 else
                   $stdout
                 end
        debugger = Debugger.new(output)

        define_method(:debug) do |*args, **kwd, &block|
          debugger.debug(*args, **kwd, &block)
        end
      end
    end
  end
end
