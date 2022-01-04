{
  description = "🔮 Visibility Across Space and Time – The network telemetry engine for data-driven security investigations.";
  #https://github.com/tenzir/vast
  nixConfig.extra-substituters = "https://zeek.cachix.org";
  nixConfig.extra-trusted-public-keys = "zeek.cachix.org-1:w590YE/k5sB26LSWvDCI3dccCXipBwyPenhBH2WNDWI=";
  nixConfig = {
    flake-registry = "https://github.com/hardenedlinux/flake-registry/raw/main/flake-registry.json";
  };


  inputs = {
    flake-compat.flake = false;
    zeek-vast-src = { url = "github:tenzir/zeek-vast"; flake = false; };
    vast-overlay = {
      url = "github:gtrunsec/vast/nix-withPlugin";
      flake = false;
    };
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , flake-compat
    , devshell
    , nixpkgs-hardenedlinux
    , vast-overlay
    , ...
    }@inputs:
      with inputs;
      flake-utils.lib.eachDefaultSystem
        (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                self.overlay
                devshell.overlay
                (import (vast-overlay + "/nix/overlay.nix"))
              ];
              config = { };
            };
          in
          with pkgs;
          rec {
            # for arion flake compat;
            inherit pkgs;

            checks = { } // (removeAttrs packages [ "vast-latest" "vast-release" "pyvast" "pyvast-latest" ]);

            packages = flake-utils.lib.flattenTree
              {
                vast-release = pkgs.vast-release;
                vast-latest = pkgs.vast-latest;
                pyvast = pkgs.pyvast;
                pyvast-latest = pkgs.pyvast-latest;
              } // lib.optionalAttrs pkgs.stdenv.isLinux {
              inherit (pkgs.vast-vm-tests)
                vast-vm-systemd;
            };

            apps = {
              vast-release = {
                type = "app";
                program = "${pkgs.vast-release}/bin/vast";
              };
              vast-latest = { type = "app"; program = "${pkgs.vast-latest}/bin/vast"; };
            };

            defaultPackage = pkgs.vast-release;

            hydraJobs = {
              inherit packages;
            };

            devShell = with pkgs; pkgs.devshell.mkShell {
              imports = [ (pkgs.devshell.importTOML ./nix/devshell.toml) ];
              commands = with pkgs; [
                # {
                #   name = pkgs.vast-latest.pname;
                #   help = pkgs.vast-latest.meta.description;
                #   package = pkgs.vast-latest;
                # }
              ];
            };
          }
        ) // {
        overlay = final: prev:
          let
            kversion = v: builtins.elemAt (prev.lib.splitString "-" v) 0;
          in
          {
            vast-sources = prev.callPackage ./nix/_sources/generated.nix { };

            pyvast = with final;
              (python3Packages.buildPythonPackage {
                pname = "pyvast";
                version = vast-sources.vast-release.version + "-release";
                src = vast-sources.vast-release.src + "/pyvast";
                doCheck = false;
                propagatedBuildInputs = with python3Packages; [
                  aiounittest
                ];
              });

            pyvast-latest = with final; (pyvast.overridePythonAttrs (old: {
              src = vast-sources.vast-latest.src + "/pyvast";
              version = (builtins.substring 0 7 vast-sources.vast-latest.version) + "-latest-dirty";
            }));

            vast-release = with final; (vast.override
              ({
                vast-source = vast-sources.vast-release.src;
                versionOverride = vast-sources.vast-release.version;
                withPlugins = [ "pcap" "broker" ];
              })).overrideAttrs (old: {
              #vast> 2021-06-30 04:44:38 WARNING  baseline comparison failed
              doInstallCheck = false;

              cmakeFlags = old.cmakeFlags ++ lib.optionals stdenv.isLinux [
                "-DVAST_ENABLE_JOURNALD_LOGGING=ON"
                "-DVAST_ENABLE_BUNDLED_CAF=OFF"
              ];

              buildInputs = old.buildInputs ++ lib.optionals stdenv.isLinux [
                systemdMinimal
              ];
            });

            vast-vm-tests = prev.lib.optionalAttrs prev.stdenv.isLinux (import ./nixos-test.nix
              {
                makeTest = (import (prev.path + "/nixos/tests/make-test-python.nix"));
                pkgs = final;
                inherit self;
              });

            vast-latest = with final; (vast-release.override (old: {
              vast-source = vast-sources.vast-latest.src;
              versionOverride = (kversion vast-sources.vast-release.version + "-") + (builtins.substring 0 7 final.vast-sources.vast-latest.version) + "-dirty";
            })
            ).overrideAttrs (old: {
              patches = [ ];
            });
          };
      } // {
        nixosModules.vast = {
          imports = [
            {
              nixpkgs.config.packageOverrides = pkgs: {
                inherit (self.packages."${pkgs.stdenv.hostPlatform.system}") vast-latest;
              };
            }
            ./module.nix
          ];
        };
      };
}
