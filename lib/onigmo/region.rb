# frozen_string_literal: true

module Onigmo
  class Region
    SIZE = 16

    attr_reader :address

    def initialize(address)
      @address = address
    end

    def allocated
      Onigmo.memory.read(address, 4).unpack1("L")
    end

    def num_regs
      Onigmo.memory.read(address + 4, 4).unpack1("L")
    end

    def get_beg
      Onigmo.memory.read(address + 8, 4).unpack1("L")
    end

    def get_end
      Onigmo.memory.read(address + 12, 4).unpack1("L")
    end

    def self.create(fields)
      start_addr = Onigmo.malloc(SIZE)
      in_order = [
        fields[:allocated],
        fields[:num_regs],
        fields[:beg],
        fields[:end]
      ]

      Onigmo.memory.write(start_addr, in_order.pack("L*"))
      new(start_addr)
    end

    def beg_at(index)
      addr = get_beg + (index * 4)
      Onigmo.memory.read(addr, 4).unpack1("L")
    end

    def end_at(index)
      addr = get_end + (index * 4)
      Onigmo.memory.read(addr, 4).unpack1("L")
    end
  end
end
