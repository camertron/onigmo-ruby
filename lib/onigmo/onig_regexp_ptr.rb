# frozen_string_literal: true

module Onigmo
  # Pointer to a pointer to a regexp_t
  class OnigRegexpPtr
    SIZE = 4

    attr_reader :address

    def initialize(address)
      @address = address
    end

    def deref
      Onigmo.memory.read(address, 4).unpack1("L")
    end

    def self.create
      start_addr = Onigmo.malloc(SIZE)
      Onigmo.memory.write(start_addr, [0].pack("L"));
      new(start_addr)
    end
  end
end
