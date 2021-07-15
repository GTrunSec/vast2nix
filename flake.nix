{
  description = "🔮 Visibility Across Space and Time – The network telemetry engine for data-driven security investigations.";
  #https://github.com/tenzir/vast

  inputs = {
    zeek-vast-src = { url = "github:tenzir/zeek-vast"; flake = false; };
    nixpkgs.url = "nixpkgs/release-21.05";
    flake-utils.url = "github:numtide/flake-utils";
    devshell-flake.url = "github:numtide/devshell";
    nvfetcher = { url = "github:berberman/nvfetcher"; };
    vast-overlay = {
      #url = "github:tenzir/vast";
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
              (final: prev: { nvfetcher-bin = nvfetcher.defaultPackage."${final.system}"; })
              devshell-flake.overlay
              (import (vast-overlay + "/nix/overlay.nix"))
            ];
            config = { allowBroken = true; };
          };
        in
        with pkgs;
        rec {
          packages = flake-utils.lib.flattenTree
            {
              vast-release = pkgs.vast-release;
              vast-latest = pkgs.vast-latest;
              vast-native = pkgs.vast-native;
              pyvast = pkgs.pyvast;
              pyvast-latest = pkgs.pyvast-latest;
            } // lib.optionalAttrs pkgs.stdenv.isLinux {
            vast-vm-tests = pkgs.vast-vm-tests.vast-systemd;
          };

          apps = {
            vast-release = { type = "app"; program = "${pkgs.vast-release}/bin/vast"; };
            vast-latest = { type = "app"; program = "${pkgs.vast-latest}/bin/vast"; };
            vast-native = { type = "app"; program = "${pkgs.vast-native}/bin/vast"; };
          };

          defaultPackage = pkgs.vast-release;

          hydraJobs = {
            inherit packages;
          };

          devShell = with pkgs; devshell.mkShell {
            imports = [ (devshell.importTOML ./nix/devshell.toml) ];
            packages = [
              nixpkgs-fmt
            ];
            commands = with pkgs; [
              {
                name = pkgs.nvfetcher-bin.pname;
                help = pkgs.nvfetcher-bin.meta.description;
                command = "cd $DEVSHELL_ROOT/nix; ${pkgs.nvfetcher-bin}/bin/nvfetcher -c ./sources.toml --no-output $@; nixpkgs-fmt _sources";
              }
            ];
          };
        }
      ) // {
      overlay = final: prev:
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
            })).overrideAttrs (old: {
            #vast> 2021-06-30 04:44:38 WARNING  baseline comparison failed
            doInstallCheck = false;

            #TODO: will be removed in next release version
            patches = [ ./nix/gcc_11.patch ];

            cmakeFlags = old.cmakeFlags ++ lib.optionals stdenv.isLinux [
              "-DVAST_ENABLE_JOURNALD_LOGGING=ON"
            ]; #++ lib.optional (!stdenv.hostPlatform.isStatic) [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

            buildInputs = old.buildInputs ++ lib.optionals stdenv.isLinux [
              systemd
            ];
          });

          vast-vm-tests = prev.lib.optionalAttrs prev.stdenv.isLinux (import ./nixos-test.nix
            {
              makeTest = (import (prev.path + "/nixos/tests/make-test-python.nix"));
              pkgs = final;
              inherit self;
            });

          vast-native = with final; (vast-release.override (old: {
            vast-source = vast-sources.vast-latest.src;
            versionOverride = (final.vast-sources.vast-release.version + "-") + (builtins.substring 0 7 final.vast-sources.vast-latest.version) + "-dirty";
            #withPlugins = [ "pcap" "broker" ];
          })).overrideAttrs (old: {
            patches = [ ];
          });

          vast-latest = with final; (pkgsStatic.vast.override (old: {
            vast-source = vast-sources.vast-latest.src;
            versionOverride = (final.vast-sources.vast-release.version + "-") + (builtins.substring 0 7 final.vast-sources.vast-latest.version) + "-dirty";
            withPlugins = [ "pcap" "broker" ];
          })).overrideAttrs (old: {
            # static issue with systemd
            # cmakeFlags = old.cmakeFlags ++ (lib.optional stdenv.isLinux [
            #   "-DVAST_ENABLE_JOURNALD_LOGGING=ON"
            # ]);
            # buildInputs = old.buildInputs ++ (lib.optional stdenv.isLinux [
            #   systemd
            # ]);
          });
        };

      nixosModules.vast = { lib, pkgs, config, ... }:
        with lib;
        let
          cfg = config.services.vast;
          configFile = pkgs.writeText "vast.yaml"
            (
              builtins.toJSON {
                vast = {
                  endpoint = cfg.endpoint;
                  db-directory = cfg.dataDir;
                } // cfg.extraConfig;
              });
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
                  type = types.attrsOf types.anything;
                  default = { };
                };

                package = mkOption {
                  type = types.package;
                  default = self.outputs.packages."${pkgs.system}".vast-native;
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
              { isSystemUser = true; group = "vast"; };

            users.groups.vast = { };

            systemd.services.vast = {
              enable = true;
              description = "Visibility Across Space and Time";
              wantedBy = [ "multi-user.target" ];

              after = [
                "network.target"
                #"zeek.service
              ];

              confinement = {
                enable = true;
                binSh = null;
              };

              script = ''
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
