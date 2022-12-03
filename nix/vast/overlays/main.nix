{inputs}: final: prev: let
  kversion = v: builtins.elemAt (prev.lib.splitString "-" v) 0;
in {
  vast-sources = prev.callPackage ../packages/_sources/generated.nix {};

  stix2-patterns = with final; (
    python3Packages.buildPythonPackage rec {
      inherit (final.vast-sources.stix2-patterns) src version pname;
      doCheck = false;
      propagatedBuildInputs = with python3Packages; [
        antlr4-python3-runtime
        six
      ];
      postPatch = ''
        substituteInPlace setup.py \
          --replace 'antlr4-python3-runtime~=4.9.0' 'antlr4-python3-runtime'
      '';
    }
  );

  stix2 = with final; (
    python3Packages.buildPythonPackage rec {
      inherit (final.vast-sources.stix2) src version pname;
      doCheck = false;
      propagatedBuildInputs = with python3Packages; [
        stix2-patterns
        requests
        pytz
        simplejson
      ];
    }
  );

  pyvast = with final; let
    dynaconf = with final;
      python3Packages.buildPythonPackage rec {
        inherit (final.vast-sources.dynaconf) src version pname;
        doCheck = false;
        propagatedBuildInputs = with python3Packages; [
          setuptools
        ];
      };
  in (
    python3Packages.buildPythonPackage {
      pname = "pyvast";
      format = "pyproject";
      version = vast-sources.vast-release.version + "-release";
      src = vast-sources.vast-release.src + "/python";
      doCheck = false;
      propagatedBuildInputs = with python3Packages; [
        poetry
        pandas
        pyarrow
        coloredlogs
        dynaconf
        stix2
      ];
      postPatch = ''
        substituteInPlace pyproject.toml \
          --replace 'pyarrow = "^10.0"' 'pyarrow = "*"' \
          --replace 'pandas = "^1.5"' 'pandas = "*"'
      '';
    }
  );
  pyvast-latest = with final; (
    pyvast.overridePythonAttrs (
      old: {
        format = "pyproject";
        src = vast-sources.vast-latest.src + "/python";
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
