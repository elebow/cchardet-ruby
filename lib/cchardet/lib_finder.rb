# frozen_string_literal: true

module CChardet
  class LibFinder
    PREFIXES = ["/usr/lib",
                "/usr/lib/x86_64-linux-gnu/",
                "/usr/local/lib",
                "/opt/local/lib"].freeze

    def lib_path
      if built_in_gem?
        # Load the library that was built inside this gem source tree
        return lib_in_gem_path
      end

      PREFIXES.each do |prefix|
        candidate_path = "#{prefix}/libuchardet.so.0"
        return candidate_path if File.exist?(candidate_path)
      end

      raise "could not find `libuchardet.so.0` in #{PREFIXES}. Install it, or install this gem with `--with-unreleased-uchardet` to build the included version."
    end

    def built_in_gem?
      File.exist?(lib_in_gem_path)
    end

    def lib_in_gem_path
      @lib_in_gem_path ||= File.expand_path("#{__dir__}/../../ext/uchardet/src/libuchardet.so")
    end
  end
end
