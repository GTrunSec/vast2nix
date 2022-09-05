# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  vast-bin = {
    pname = "vast-bin";
    version = "v2.3.0";
    src = fetchurl {
      url = "https://github.com/tenzir/vast/releases/download/v2.3.0/vast-linux-static.tar.gz";
      sha256 = "sha256-Rak6/qK6vwVUOtg4f/ErXghmUiQ00pGtASlsh692uoQ=";
    };
  };
  vast-latest = {
    pname = "vast-latest";
    version = "6f9c841980b2333028b1ac19e2a21e99d96cbd36";
    src = fetchFromGitHub ({
      owner = "tenzir";
      repo = "vast";
      rev = "6f9c841980b2333028b1ac19e2a21e99d96cbd36";
      fetchSubmodules = true;
      sha256 = "sha256-UkVTSPFCHl6UB0yDovdqqMtPPEZ1MuLPX9deywf8FCc=";
    });
  };
  vast-release = {
    pname = "vast-release";
    version = "v2.3.0";
    src = fetchFromGitHub ({
      owner = "tenzir";
      repo = "vast";
      rev = "v2.3.0";
      fetchSubmodules = true;
      sha256 = "sha256-dSZk6R6tgrPRq4qNTmq4e8ApCFG+CogNBNz0gRLuiGA=";
    });
  };
}
