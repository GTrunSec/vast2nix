# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  dynaconf = {
    pname = "dynaconf";
    version = "3.1.11";
    src = fetchurl {
      url = "https://pypi.io/packages/source/d/dynaconf/dynaconf-3.1.11.tar.gz";
      sha256 = "sha256-2c+1D9SnGlQ/0jhF1PWFtiC2/22dPMGCXGFPeyCXyzk=";
    };
  };
  stix2 = {
    pname = "stix2";
    version = "3.0.1";
    src = fetchurl {
      url = "https://pypi.io/packages/source/s/stix2/stix2-3.0.1.tar.gz";
      sha256 = "sha256-KicY3DRRyExwmZCyyiIMw5x17SPghk1+jYGQqTZbDL8=";
    };
  };
  stix2-patterns = {
    pname = "stix2-patterns";
    version = "2.0.0";
    src = fetchurl {
      url = "https://pypi.io/packages/source/s/stix2-patterns/stix2-patterns-2.0.0.tar.gz";
      sha256 = "sha256-B3UMWlryx1jp0qpN3p2OBLzRYqwqmwtMTeRIHUQ++gg=";
    };
  };
  vast-bin = {
    pname = "vast-bin";
    version = "v2.4.1";
    src = fetchurl {
      url = "https://github.com/tenzir/vast/releases/download/v2.4.1/vast-linux-static.tar.gz";
      sha256 = "sha256-du0Nny1FL1lqzbC+FtcHbk0dDlmM3ZfwbRnO5Sx46Wk=";
    };
  };
  vast-latest = {
    pname = "vast-latest";
    version = "4eba778b74b49c880341e0fbc4cc5dd4ddfa367c";
    src = fetchFromGitHub ({
      owner = "tenzir";
      repo = "vast";
      rev = "4eba778b74b49c880341e0fbc4cc5dd4ddfa367c";
      fetchSubmodules = false;
      sha256 = "sha256-hglYguhvSmD/u6KrOlNOwuV7Es7bUbpqpHCibpmUC6o=";
    });
    date = "2023-03-01";
  };
  vast-release = {
    pname = "vast-release";
    version = "v2.4.1";
    src = fetchFromGitHub ({
      owner = "tenzir";
      repo = "vast";
      rev = "v2.4.1";
      fetchSubmodules = false;
      sha256 = "sha256-9D4h2ibdWlXCdlsKyWtsjm0PzE8GDmolYodAoxcOHRc=";
    });
  };
}
