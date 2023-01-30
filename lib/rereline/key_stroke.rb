module Rereline
  class KeyStroke
    module Ex
      refine Array do
        def start_with?(other)
          return false if size < other.size
          take(other.size) == other
        end

        def match_status(input)
          if input.start_with? self
            :matched
          elsif self.start_with? input
            :matching
          else
            :unmatched
          end
        end

        def matched?(input)
          match_status(input) == :matched
        end

        def matching?(input)
          match_status(input) == :matching
        end

        def unmatched?(input)
          match_status(input) == :unmatched
        end
      end
    end
    using Ex

    attr_reader :mapping

    def initialize(mapping)
      @mapping = mapping
    end

    def expand(input, wait_match: true)
      if input.empty?
        [[], []]
      elsif wait_match && matching?(input)
        [[], input]
      elsif matched?(input)
        lhs, rhs = mapping.filter { |lhs, rhs| lhs.matched? input }.max_by { |lhs, rhs| lhs.size }
        if (after_input = input.drop(lhs.size)).size > 0
          # NOTE: 再帰的にマッピングされているキーを展開する時に後続のキーが存在している場合は待ち処理はせずに展開する
          join(expand(rhs, wait_match: false), expand(after_input, wait_match: wait_match))
        else
          expand(rhs, wait_match: wait_match)
        end
      else
        join([input.take(1), []], expand(input.drop(1), wait_match: wait_match))
      end
    end

    private

    def matching?(input)
      mapping.any? { |lhs, rhs| lhs.matching? input }
    end

    def matched?(input)
      mapping.any? { |lhs, rhs| lhs.matched? input }
    end

    def match_status(input)
      mapping.map { |lhs, rhs| lhs.match_status input }
    end

    private

    # a = [[1, 2], [3, 4]]
    # b = [[:a, :b], [:c, :d]]
    # join(a, b)
    # => [[1, 2, :a, :b], [3, 4, :c, :d]]
    def join(a, b)
      [a, b].transpose.map { |it| it.inject(&:+) }
    end
  end
end
