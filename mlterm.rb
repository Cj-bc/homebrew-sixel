class Mlterm < Formula
  homepage "http://mlterm.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mlterm/01release/mlterm-3.7.0/mlterm-3.7.0.tar.gz"
  head "https://bitbucket.org/arakiken/mlterm", :using => :hg
  sha256 "4a81d9e1957e4f0b8f8e0838ddad0cf4776fabc73465d886f2211bb8d990c339"

  depends_on "pkg-config" => :build
  depends_on :x11 => :optional

  stable do
    patch :DATA
  end

  def install
    args = ["--prefix=#{prefix}",
           ]

    if build.with? "x11"
      args << "--with-gui=xlib"
      args << "--enable-utmp=no"

      system "./configure", *args
      system "make", "install"
    else # Cocoa
      args << "--with-gui=quartz"

      system "./configure", *args
      system "make", "install"

      inreplace "cocoa/install.sh", "$HOME", "#{buildpath}/cocoa"
      system "cocoa/install.sh", "#{prefix}"
      prefix.install "cocoa/mlterm.app"

      (bin/"mlterm").unlink # Kill the existing symlink
      (bin/"mlterm").write <<-EOS.undent
          #!/bin/bash
          exec #{prefix}/mlterm.app/Contents/MacOS/mlterm "$@"
        EOS
    end

  end

end

__END__
diff -r 61224c609927 mlterm/ml_char.c
--- a/mlterm/ml_char.c	Thu Apr 28 02:09:38 2016 +0900
+++ b/mlterm/ml_char.c	Sat Apr 30 03:59:42 2016 +0900
@@ -189,7 +189,7 @@
 	return  multi_ch + comb_size ;
 }
 
-#ifdef  __APPLE__
+#ifdef  USE_QUARTZ
 static void
 normalize(
 	ml_char_t *  ch ,
@@ -465,7 +465,7 @@
 	}
 }
 
-#ifdef  __APPLE__
+#ifdef  USE_QUARTZ
 #include  <kiklib/kik_mem.h>
 int  ml_normalize( u_int16_t *  str , int  num) ;
 #endif
@@ -521,7 +521,7 @@
 		return  NULL ;
 	}
 
-#ifdef  __APPLE__
+#ifdef  USE_QUARTZ
 	normalize( ch , comb_size) ;
 #endif
 
@@ -557,7 +557,7 @@
 	*comb = *src ;
 	UNSET_COMB_TRAILING(comb->u.ch.attr) ;
 
-#ifdef  __APPLE__
+#ifdef  USE_QUARTZ
 	normalize( ch , comb_size) ;
 #endif
 
