# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl }:
{
  vast-latest = {
    pname = "vast-latest";
    version = "527d6dd65119caa2e28ce8b6a62fda1a0e5ef7f1";
    src = fetchgit {
      url = "https://github.com/tenzir/vast";
      rev = "527d6dd65119caa2e28ce8b6a62fda1a0e5ef7f1";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "00dpx285klp2xpb9lbmk4l79df4ipd81p3g3igrd1dfh3h86fgsw";
    };
  };
  vast-release = {
    pname = "vast-release";
    version = "2021.08.26";
    src = fetchgit {
      url = "https://github.com/tenzir/vast";
      rev = "2021.08.26";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0g1vv2jj73fddz86pnn5kp3g89z0iyf2hbf5hcj77rxh7a001j7q";
    };
  };
}
