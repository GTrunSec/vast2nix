# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  vast-bin = {
    pname = "vast-bin";
    version = "v2.2.0";
    src = fetchurl {
      url = "https://github.com/tenzir/vast/releases/download/v2.1.0-rc3/vast-linux-static.tar.gz";
      sha256 = "sha256-wY37OMDwvecirzAHxdUG3H31mPNZy25niUTlaU21UTw=";
    };
  };
  vast-latest = {
    pname = "vast-latest";
    version = "2d2906ad8658d3ee3e534404bd5bd43bc06e77f9";
    src = fetchFromGitHub ({
      owner = "tenzir";
      repo = "vast";
      rev = "2d2906ad8658d3ee3e534404bd5bd43bc06e77f9";
      fetchSubmodules = true;
      sha256 = "sha256-NUIcpmXVZDNego5CC42Og9CcSw3i/gc4PAhYdl9jbDc=";
    });
  };
  vast-release = {
    pname = "vast-release";
    version = "v2.2.0";
    src = fetchFromGitHub ({
      owner = "tenzir";
      repo = "vast";
      rev = "v2.2.0";
      fetchSubmodules = true;
      sha256 = "sha256-jraQcAvOJsA/exmyI/8YQufg5n5xrnqlCpLm6mRmsss=";
    });
  };
}
