# frozen_string_literal: true

require "fiddle"
require "fiddle/import"

require_relative "cchardet/version"

module CChardet
  extend Fiddle::Importer

  # Load the library that was built inside this gem source tree
  dlload File.expand_path("#{__dir__}/../ext/uchardet/src/libuchardet.so")

  typealias "uchardet_t", "void *"

  extern "uchardet_t uchardet_new(void)"
  extern "void uchardet_delete(uchardet_t ud)"
  extern "int uchardet_handle_data(uchardet_t ud, const char *data, size_t len)"
  extern "void uchardet_data_end(uchardet_t ud)"
  extern "void uchardet_reset(uchardet_t ud)"
  extern "const char *uchardet_get_charset(uchardet_t ud)"
  extern "float uchardet_get_confidence(uchardet_t ud)"

  def self.detect(str)
    uchardet_obj = uchardet_new
    uchardet_handle_data(uchardet_obj, str, 1)
    uchardet_data_end(uchardet_obj)

    {
      charset: uchardet_get_charset(uchardet_obj).to_s,
      confidence: uchardet_get_confidence(uchardet_obj)
    }
  end
end
