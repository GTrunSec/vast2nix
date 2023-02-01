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
    version = "v2.4.0-rc2";
    src = fetchurl {
      url = "https://github.com/tenzir/vast/releases/download/v2.4.0-rc2/vast-linux-static.tar.gz";
      sha256 = "sha256-2SsA25GBM3iaCaBXnxZphMv+XMR9A3MUMDIPk0ftvOw=";
    };
  };
  vast-latest = {
    pname = "vast-latest";
    version = "64a1e368dcea069cca4ddd28f4c1710233f3e1c1";
    src = fetchFromGitHub ({
      owner = "tenzir";
      repo = "vast";
      rev = "64a1e368dcea069cca4ddd28f4c1710233f3e1c1";
      fetchSubmodules = true;
      sha256 = "sha256-nSMwZyQg1H2Oe/wvHg3BXJhoykPJqdsg1Q1MlGc1iYo=";
    });
    date = "2023-02-01";
  };
  vast-release = {
    pname = "vast-release";
    version = "v2.4.1";
    src = fetchFromGitHub ({
      owner = "tenzir";
      repo = "vast";
      rev = "v2.4.1";
      fetchSubmodules = true;
      sha256 = "sha256-eays8RvVqU9VXPq7Cuf91o2czIp9gKjaJUQXTV7SiEE=";
    });
  };
}
