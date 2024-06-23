# frozen_string_literal: true

module Onigmo
  class CompileInfo
    SIZE = 24

    attr_reader :address

    def initialize(address)
      @address = address
    end

    def self.create(fields)
      start_addr = Onigmo.malloc(SIZE)

      in_order = [
        fields[:num_of_elements],
        fields[:pattern_enc],
        fields[:target_enc],
        fields[:syntax],
        fields[:option],
        fields[:case_fold_flag]
      ]

      Onigmo.memory.write(start_addr, in_order.pack("L*"))
      new(start_addr)
    end
  end
end
