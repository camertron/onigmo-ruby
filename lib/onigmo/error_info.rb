# frozen_string_literal: true

module Onigmo
  class ErrorInfo
    SIZE = 12

    attr_reader :address

    def initialize(address)
      @address = address
    end

    def self.create(fields)
      start_addr = Onigmo.malloc(SIZE)
      in_order = [
        fields[:enc],
        fields[:par],
        fields[:par_end]
      ]

      Onigmo.memory.write(start_addr, in_order.pack("L*"))
      new(start_addr)
    end
  end
end
