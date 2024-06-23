# frozen_string_literal: true

module Onigmo
  class OnigRegexp
    ONIG_NORMAL = 0
    ONIG_MISMATCH = -1

    ONIG_MAX_ERROR_MESSAGE_LEN = 90

    ONIG_OPTION_NONE = 0

    REGION_FREE_CONTENTS_ONLY = 0
    REGION_FREE_SELF = 1

    def self.compile(pat)
      compile_info = Onigmo::CompileInfo.create(make_compile_info)
      regexp_ptr = Onigmo::OnigRegexpPtr.create
      errorinfo = Onigmo::ErrorInfo.create({enc: 0, par: 0, par_end: 0})
      pattern = Onigmo::Utf16String.create(pat)

      error_code = Onigmo.onig_new_deluxe(
        regexp_ptr.address,
        pattern.start_addr,
        pattern.end_addr,
        compile_info.address,
        errorinfo.address
      )

      if error_code == ONIG_NORMAL
        regexp = regexp_ptr.deref

        Onigmo.free(compile_info.address)
        Onigmo.free(regexp_ptr.address)
        Onigmo.free(errorinfo.address)

        new(pat, regexp)
      else
        err_msg = OnigRegexp.error_code_to_string(error_code, errorinfo)

        Onigmo.free(compile_info.address)
        Onigmo.free(regexp_ptr.address)
        Onigmo.free(errorinfo.address)

        raise RuntimeError, err_msg
      end
    end

    def self.make_compile_info
      {
        num_of_elements: 5,
        pattern_enc: Onigmo::OnigEncodingUTF_16LE,
        target_enc: Onigmo::OnigEncodingUTF_16LE,
        syntax: Onigmo::OnigSyntaxRuby,
        option: 0,
        case_fold_flag: Onigmo::OnigDefaultCaseFoldFlag
      }
    end

    def self.error_code_to_string(error_code, errorinfo)
      err_msg_ptr = Onigmo.malloc(ONIG_MAX_ERROR_MESSAGE_LEN)
      err_msg_len = Onigmo.onig_error_code_to_str(err_msg_ptr, error_code, errorinfo ? errorinfo.address : 0)
      err_msg = ASCIIString.new(err_msg_ptr, err_msg_ptr + err_msg_len)
      Onigmo.free(err_msg_ptr)
      err_msg.to_string
    end

    attr_reader :pat, :regexp

    def initialize(pat, regexp)
      @pat = pat
      @regexp = regexp
    end

    def search(str, start_pos = nil, end_pos = nil)
      start_pos ||= 0

      if start_pos < 0 || start_pos >= str.size
        return nil
      end

      end_pos ||= str.size

      if end_pos < 0 || end_pos > str.size
        return nil
      end

      str_ptr = Onigmo::Utf16String.create(str)
      region = Onigmo::Region.new(Onigmo.onig_region_new)

      exit_code_or_position = Onigmo.onig_search(
        regexp,
        str_ptr.start_addr,
        str_ptr.end_addr,
        str_ptr.start_addr + (start_pos * 2),
        str_ptr.start_addr + (end_pos * 2),
        region.address,
        ONIG_OPTION_NONE
      )

      result = if exit_code_or_position <= -2
        error_msg = self.class.error_code_to_string(exit_code_or_position)
        raise RuntimeError, error_msg
      elsif exit_code_or_position == ONIG_MISMATCH
        nil
      else
        Onigmo::OnigMatchData.from_region(str, region)
      end

      Onigmo.free(str_ptr.start_addr)
      Onigmo.onig_region_free(region.address, REGION_FREE_CONTENTS_ONLY)

      result
    end
  end
end
