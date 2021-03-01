# frozen_string_literal: true

require "fiddle"
require "fiddle/import"

require_relative "cchardet/lib_finder"
require_relative "cchardet/version"

module CChardet
  extend Fiddle::Importer

  lib_finder = CChardet::LibFinder.new
  IN_GEM_LIB = lib_finder.built_in_gem?.freeze

  dlload lib_finder.lib_path

  typealias "uchardet_t", "void *"

  extern "uchardet_t uchardet_new(void)"
  extern "void uchardet_delete(uchardet_t ud)"
  extern "int uchardet_handle_data(uchardet_t ud, const char *data, size_t len)"
  extern "void uchardet_data_end(uchardet_t ud)"
  extern "void uchardet_reset(uchardet_t ud)"
  if IN_GEM_LIB
    extern "size_t uchardet_get_candidates(uchardet_t ud)"
    extern "float uchardet_get_confidence(uchardet_t ud, size_t candidate)"
    extern "const char *uchardet_get_encoding(uchardet_t ud, size_t candidate)"
    extern "const char *uchardet_get_language(uchardet_t ud, size_t candidate)"
    extern "void uchardet_weigh_language(uchardet_t ud, const char *language, float weight)"
    extern "void uchardet_set_default_weight(uchardet_t ud, float weight)"
  else
    extern "const char *uchardet_get_charset(uchardet_t ud)"
  end

  def self.detect(str)
    uchardet_obj = uchardet_new
    uchardet_handle_data(uchardet_obj, str, str.bytesize)
    uchardet_data_end(uchardet_obj)

    return { encoding: uchardet_get_charset(uchardet_obj).to_s } unless IN_GEM_LIB

    num_candidates = uchardet_get_candidates(uchardet_obj)

    (0..num_candidates - 1).map do |i|
      {
        encoding: uchardet_get_encoding(uchardet_obj, i).to_s,
        confidence: uchardet_get_confidence(uchardet_obj, i),
        language: uchardet_get_language(uchardet_obj, i).yield_self do |lang_ptr|
                    lang_ptr.null? ? nil : lang_ptr.to_s
                  end
      }
    end
  ensure
    uchardet_delete(uchardet_obj)
  end
end
