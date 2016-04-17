class Mlterm < Formula
  homepage "http://mlterm.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mlterm/01release/mlterm-3.7.0/mlterm-3.7.0.tar.gz"
  sha256 "4a81d9e1957e4f0b8f8e0838ddad0cf4776fabc73465d886f2211bb8d990c339"

  depends_on "pkg-config" => :build

  def install
    args = ["--prefix=#{prefix}",
            "--with-gui=quartz",
           ]

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
