{
  description = "🔮 Visibility Across Space and Time – The network telemetry engine for data-driven security investigations.";
  #https://github.com/tenzir/vast
  nixConfig.extra-substituters = "https://zeek.cachix.org";
  nixConfig.extra-trusted-public-keys = "zeek.cachix.org-1:w590YE/k5sB26LSWvDCI3dccCXipBwyPenhBH2WNDWI=";

  inputs = {
    zeek-vast-src = { url = "github:tenzir/zeek-vast"; flake = false; };
    zeek2nix = { url = "github:hardenedlinux/zeek2nix"; };

    flake-utils.follows = "zeek2nix/flake-utils";
    nixpkgs.follows = "zeek2nix/nixpkgs";
    nixpkgs-hardenedlinux.follows = "zeek2nix/nixpkgs-hardenedlinux";
    nvfetcher.follows = "zeek2nix/nvfetcher";
    devshell.follows = "zeek2nix/devshell";
    flake-compat = { follows = "zeek2nix/flake-compat"; flake = false; };
    vast-overlay = {
      url = "github:gtrunsec/vast/nix-withPlugin";
      flake = false;
    };
  };

  outputs = inputs: with builtins;
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

          devShell = with pkgs; devshell.mkShell {
            imports = [ (devshell.importTOML ./nix/devshell.toml) ];
            commands = with pkgs; [
              # {
              #   name = pkgs.vast-latest.pname;
              #   help = pkgs.vast-latest.meta.description;
              #   package = pkgs.vast-latest;
              # }
              {
                name = nvfetcher.defaultPackage.x86_64-linux.pname;
                help = nvfetcher.defaultPackage.x86_64-linux.meta.description;
                command = "export NIX_PATH=nixpkgs=${pkgs.path}; cd $PRJ_ROOT/nix; ${nvfetcher.defaultPackage.x86_64-linux}/bin/nvfetcher -c ./sources.toml $@";
              }
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
      nixosModules.vast = { lib, pkgs, config, ... }:
        with lib;
        let
          cfg = config.services.vast;
          configFile = pkgs.writeText "vast.yaml" cfg.extraConfig;
        in
        {
          options =
            {
              services.vast = {
                enable = mkOption {
                  type = types.bool;
                  default = false;
                  description = ''
                    Whether to enable vast endpoint
                  '';
                };

                broker = mkOption {
                  type = types.bool;
                  default = false;
                  description = ''
                    Whether to enable broker to vast
                  '';
                };

                extraConfig = mkOption {
                  default = { };
                  description = ''
                    extraConfig = builtins.readFile ./config.vast.example.yaml;
                  '';
                };

                package = mkOption {
                  type = types.package;
                  default = self.outputs.packages."${pkgs.system}".vast-latest;
                  description = "The vast package.";
                };

                dataDir = mkOption {
                  type = types.str;
                  default = "/var/lib/vast";
                  description = "The file system path used for persistent state.";
                };

                endpoint = mkOption {
                  type = types.str;
                  # if the confinement is enable, the localhost does not working anymore
                  default = "127.0.0.1:4000";
                  example = "localhost:4000";
                  description = ''
                    The host and port to listen at and connect to.
                  '';
                };
              };
            };

          config = mkIf cfg.enable {
            users.users.vast =
              {
                isSystemUser = true;
                group = "vast";
                home = cfg.dataDir;
              };

            users.groups.vast = { };

            systemd.services.vast-broker = mkIf cfg.broker {
              enable = true;
              description = "Vast import broker Daemon";
              wantedBy = [ "multi-user.target" ];
              bindsTo = [ "vast.service" ];
              after = [
                "network-online.target"
                "vast.service"
              ];
              path = [ cfg.package ];
              script = ''
                exec ${cfg.package}/bin/vast --config=${configFile} import broker
              '';
              serviceConfig = {
                User = "vast";
                Group = "vast";
                ExecReload = "/bin/kill -s HUP $MAINPID";
                Restart = "on-failure";
                WorkingDirectory = cfg.dataDir;
                ReadWritePaths = cfg.dataDir;
                RuntimeDirectory = "vast";
                CacheDirectory = "vast";
                StateDirectory = "vast";
                SyslogIdentifier = "vast";
              };
            };

            systemd.services.vast = {
              enable = true;
              description = "Visibility Across Space and Time";
              wantedBy = [ "multi-user.target" ];

              after = [
                "network-online.target"
                #"zeek.service
              ];

              confinement = {
                enable = true;
                binSh = null;
              };

              script = ''
                ln -sf ${configFile} ${cfg.dataDir}/vast.yaml
                exec ${cfg.package}/bin/vast --config=${configFile} start
              '';

              serviceConfig = {
                Restart = "on-failure";
                RestartSec = "10";
                ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID && ${pkgs.coreutils}/bin/rm ${cfg.dataDir}/vast.db/pid.lock";
                User = "vast";
                WorkingDirectory = cfg.dataDir;
                ReadWritePaths = cfg.dataDir;
                RuntimeDirectory = "vast";
                CacheDirectory = "vast";
                StateDirectory = "vast";
                SyslogIdentifier = "vast";
                PrivateUsers = true;
                DynamicUser = mkForce false;
                PrivateTmp = true;
                ProtectHome = true;
                PrivateDevices = true;
                ProtectKernelTunables = true;
                ProtectControlGroups = true;
                ProtectKernelModules = true;
                ProtectKernelLogs = true;
              };
            };
          };
        };
    };
}
