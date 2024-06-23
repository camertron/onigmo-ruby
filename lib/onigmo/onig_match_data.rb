# frozen_string_literal: true

module Onigmo
  class OnigMatchData
    def self.from_region(str, region)
      captures = Array.new(region.num_regs) do |i|
        [region.beg_at(i) / 2, region.end_at(i) / 2]
      end

      new(str, captures)
    end

    attr_reader :str, :captures

    def initialize(str, captures)
      @str = str
      @captures = captures
    end

    def get_begin(index)
      if index >= captures.size
        raise IndexError, "index #{index} out of matches"
      end

      captures[index][0]
    end

    def get_end(index)
      if index >= captures.size
        raise IndexError, "index #{index} out of matches"
      end

      captures[index][1]
    end

    def match(index)
      if index >= captures.size
        raise IndexError, "index #{index} out of matches"
      end

      begin_, end_ = captures[index]
      str[begin_...end_]
    end
  end
end
