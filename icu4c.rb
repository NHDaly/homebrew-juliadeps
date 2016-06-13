require 'formula'

class Icu4c < Formula
  homepage 'http://site.icu-project.org/'
  head 'http://source.icu-project.org/repos/icu/icu/trunk/', :using => :svn
  url 'http://download.icu-project.org/files/icu4c/56.1/icu4c-56_1-src.tgz'
  sha256 '3a64e9105c734dcf631c0b3ed60404531bce6c0f5a64bfe1a6402a4cc2314816'
  version "56.1"

  bottle do
    root_url 'https://juliabottles.s3.amazonaws.com'
    cellar :any
    sha256 "704769bf45e8270ce4bf45d501d2c60c5878c127ffcc22fc2add26ba6b676561" => :mavericks
    sha256 "e2eac33c24e01695b227e5aabd49414a3faaa7f61445f62c16bfce21a76f3c0f" => :yosemite
    sha256 "5e86a6cf138b4c03e42518708fc14c82cdfa80e4cf791c9409701182806552cd" => :el_capitan
  end

  keg_only :provided_by_osx, "OS X provides libicucore.dylib (but nothing else)."

  option :universal
  option :cxx11

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    args = ["--prefix=#{prefix}", "--disable-samples", "--disable-tests", "--enable-static"]
    args << "--with-library-bits=64" if MacOS.prefer_64_bit?
    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
  end
end