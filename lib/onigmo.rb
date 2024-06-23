# frozen_string_literal: true

require "wasmtime"

module Onigmo
  autoload :ASCIIString,   "onigmo/ascii_string"
  autoload :CompileInfo,   "onigmo/compile_info"
  autoload :ErrorInfo,     "onigmo/error_info"
  autoload :OnigMatchData, "onigmo/onig_match_data"
  autoload :OnigRegexpPtr, "onigmo/onig_regexp_ptr"
  autoload :OnigRegexp,    "onigmo/onig_regexp"
  autoload :Region,        "onigmo/region"
  autoload :Utf16String,   "onigmo/utf16_string"

  class << self
    def instance
      @instance ||= begin
        engine = Wasmtime::Engine.new
        module_path = File.join(File.dirname(__dir__), "vendor", "onigmo.wasm")
        mod = Wasmtime::Module.from_file(engine, module_path)
        store = Wasmtime::Store.new(engine)
        Wasmtime::Instance.new(store, mod, [])
      end
    end

    def memory
      @memory ||= instance.export("memory").to_memory
    end

    private

    def self.exports_func(name)
      func = Onigmo.instance.export(name.to_s).to_func

      define_method(name) do |*args|
        func.call(*args)
      end
    end

    public

    exports_func :malloc
    exports_func :free
    exports_func :onig_new_deluxe
    exports_func :onig_region_new
    exports_func :onig_region_free
    exports_func :onig_search
    exports_func :onig_error_code_to_str
  end

  OnigEncodingUTF_16LE = instance.export("OnigEncodingUTF_16LE").to_global.get
  OnigSyntaxRuby = instance.export("OnigSyntaxRuby").to_global.get
  OnigDefaultCaseFoldFlag = instance.export("OnigDefaultCaseFoldFlag").to_global.get
end
