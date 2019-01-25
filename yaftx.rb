require "formula"

class Yaftx < Formula
  desc "yaft is simple framebuffer terminal emulator for minimalist."
  homepage "https://uobikiemukot.github.io/yaft/"
  url "http://uobikiemukot.github.io/yaft/release/yaft-0.2.9.tar.gz"
  sha256 "80f7e6937ff0a34f77859c684d6f8e23c55d696e0bac4ac8b2f11f785db0374c"
  head "https://github.com/uobikiemukot/yaft.git"

  depends_on :x11

  patch :DATA

  def install
    ENV['LANG'] = 'en_US.UTF-8'
    system "make", "yaftx"
    mkdir "#{share}/terminfo"
    system "tic -o #{share}/terminfo info/yaft.src"
    bin.install 'yaftx'
  end
end

__END__
--- a/Makefile
+++ b/Makefile
@@ -4,8 +4,8 @@ CC ?= gcc
 CFLAGS  ?= -std=c99 -pedantic -Wall -Wextra -O3 -s -pipe
 LDFLAGS ?=

-XCFLAGS  ?= -std=c99 -pedantic -Wall -Wextra -I/usr/include/X11/ -O3 -s -pipe
-XLDFLAGS ?= -lX11
+XCFLAGS  ?= -std=c99 -pedantic -Wall -Wextra -I/opt/X11/include/ -O3 -s -pipe
+XLDFLAGS ?= -lX11 -L/opt/X11/lib

 HDR = color.h conf.h dcs.h draw.h function.h osc.h parse.h terminal.h util.h yaft.h glyph.h \
        fb/linux.h fb/freebsd.h fb/netbsd.h fb/openbsd.h x/x.h
