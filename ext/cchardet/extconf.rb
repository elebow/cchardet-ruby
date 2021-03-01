# frozen_string_literal: true

require "mkmf"

open("Makefile", "w") do |makefile|
  if with_config("unreleased-uchardet")
    # Note the tab characters in the Makefile contents
    makefile.puts <<~MAKEFILE
      make:
      	cd ../uchardet && cmake . -DCMAKE_BUILD_TYPE=Release -DBUILD_BINARY=OFF && make
      install:
      	# The gem will load the library from where it was built.
      clean:
      	# Any files will be cleaned up when the gem is uninstalled.
    MAKEFILE
  else
    makefile.puts <<~MAKEFILE
      make:
      	
      install:
      	
      clean:
      	
    MAKEFILE
  end
end
