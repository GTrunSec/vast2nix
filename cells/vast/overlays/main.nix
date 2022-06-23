{inputs}: final: prev: let
  kversion = v: builtins.elemAt (prev.lib.splitString "-" v) 0;
in {
  vast-sources = prev.callPackage ../apps/_sources/generated.nix {};

  pyvast = with final; (
    python3Packages.buildPythonPackage {
      pname = "pyvast";
      version = vast-sources.vast-release.version + "-release";
      src = vast-sources.vast-release.src + "/pyvast";
      doCheck = false;
      propagatedBuildInputs = with python3Packages; [aiounittest];
    }
  );
  pyvast-latest = with final; (
    pyvast.overridePythonAttrs (
      old: {
        src = vast-sources.vast-latest.src + "/pyvast";
        version =
          (builtins.substring 0 7 vast-sources.vast-latest.version)
          + "-latest-dirty";
      }
    )
  );
  vast-release = with final;
    (
      final.pkgsStatic.vast.override {
        vast-source = vast-sources.vast-release.src;
        versionOverride = vast-sources.vast-release.version;
        withPlugins = [
          "${inputs.vast-overlay}/plugins/broker"
          "${vast-sources.vast-release.src}/plugins/pcap"
          "${vast-sources.vast-release.src}/plugins/summarize"
        ];
      }
    )
    .overrideAttrs (
      old: {
        doInstallCheck = false;
        # cmakeFlags = old.cmakeFlags ++ lib.optionals stdenv.isLinux [
        #   "-DVAST_ENABLE_JOURNALD_LOGGING=ON"
        # ];
        # buildInputs = old.buildInputs ++ lib.optionals stdenv.isLinux [
        #   systemdMinimal
        # ];
      }
    );
  vast-latest = with final;
    (
      vast-release.override (
        old: {
          vast-source = vast-sources.vast-latest.src;
          versionOverride =
            (kversion vast-sources.vast-release.version + "-")
            + (builtins.substring 0 7 final.vast-sources.vast-latest.version)
            + "-dirty";
          withPlugins = [
            "${vast-sources.vast-latest.src}/plugins/pcap"
            "${vast-sources.vast-latest.src}/plugins/broker"
            "${vast-sources.vast-latest.src}/plugins/summarize"
          ];
        }
      )
    )
    .overrideAttrs (old: {});
}
