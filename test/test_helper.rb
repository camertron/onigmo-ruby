# frozen_string_literal: true

require "onigmo"

# a little more memory plz
Onigmo.memory.grow(30)

require "minitest/autorun"
