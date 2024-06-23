# frozen_string_literal: true

module Onigmo
  class Utf16String
    attr_reader :start_addr, :end_addr

    def initialize(start_addr, end_addr)
      @start_addr = start_addr
      @end_addr = end_addr
    end

    def to_string
      Onigmo.memory.read(start_addr, end_addr - start_addr).force_encoding(Encoding::UTF_16LE)
    end

    def self.create(str)
      str = str.encode(Encoding::UTF_16LE)
      start_addr = Onigmo.malloc(str.bytesize)
      Onigmo.memory.write(start_addr, str)
      new(start_addr, start_addr + str.bytesize)
    end
  end
end
