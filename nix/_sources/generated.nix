# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
}:
{
  vast-latest = {
    pname = "vast-latest";
    version = "6739d464e4cbbbcceb3ba840fa1b417d39e7a537";
    src = fetchFromGitHub (
      {
        owner = "tenzir";
        repo = "vast";
        rev = "6739d464e4cbbbcceb3ba840fa1b417d39e7a537";
        fetchSubmodules = true;
        sha256 = "sha256-bPTBLgEDZtLcX3J9ABQW6Pdc1C2OK9/18yGccagxPgg=";
      }
    );
  };
  vast-release = {
    pname = "vast-release";
    version = "v1.0.0";
    src = fetchFromGitHub (
      {
        owner = "tenzir";
        repo = "vast";
        rev = "v1.0.0";
        fetchSubmodules = true;
        sha256 = "sha256-7ZLudaPngR35rc6iBvuous+e5nb4cKKm19autLh4ick=";
      }
    );
  };
}
