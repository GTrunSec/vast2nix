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
    version = "2fac54774a8bfa6a23679cd791c234c4e37175b0";
    src = fetchFromGitHub ({
      owner = "tenzir";
      repo = "vast";
      rev = "2fac54774a8bfa6a23679cd791c234c4e37175b0";
      fetchSubmodules = true;
      sha256 = "sha256-5ENoGBFacJ+ABv78PFN8L0TTelxPHg0Sy0sdrYK7b1U=";
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
