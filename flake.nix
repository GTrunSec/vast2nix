{
  inputs = {
    zeek-vast-src = { url = "github:tenzir/zeek-vast"; flake = false; };
    nixpkgs.url = "nixpkgs/release-21.05";
    caf = { url = "github:actor-framework/actor-framework/347917fee3420d5fa02220af861869d1728b7fc0"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-hardenedlinux = { url = "github:hardenedlinux/nixpkgs-hardenedlinux"; };
    devshell-flake.url = "github:numtide/devshell";
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vast-overlay = {
      url = "github:tenzir/vast";
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
              nixpkgs-hardenedlinux.overlay
              nvfetcher.overlay
              devshell-flake.overlay
              (import (vast-overlay + "/nix/overlay.nix"))
              #(import (vast-overlay + "/nix/overlay-dev.nix"))
            ];
            config = { allowBroken = true; };
          };
        in
        with pkgs;
        rec {
          packages = flake-utils.lib.flattenTree
            {
              vast = pkgs.vast;
              vast-latest = pkgs.vast-latest;
              pyvast = pkgs.pyvast;
              pyvast-latest = pkgs.pyvast-latest;
              # zeek-vast = pkgs.zeek-vast;
            };

          defaultPackage = pkgs.vast-release;

          hydraJobs = {
            inherit packages;
          };
          devShell = with pkgs; devshell.mkShell {
            #imports = [ (devshell.importTOML ./nix/commands.toml) ];
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
        let
          stdenv = if prev.stdenv.isDarwin then final.llvmPackages_latest.stdenv else final.stdenv;
        in
        {
          vast-sources = prev.callPackage ./nix/_sources/generated.nix { };
          # zeek-vast = final.vast.overrideAttrs (old: rec {
          #   preConfigure = (old.preConfigure or "") + ''
          #     ln -s ${zeek-vast-src}/zeek-to-vast tools/.
          #   '';
          #   cmakeFlags = (old.cmakeFlags or [ ]) ++ [
          #     "-DBROKER_ROOT_DIR=${final.broker}"
          #   ];
          # });

          pyvast = with final;
            (python3Packages.buildPythonPackage {
              pname = "pyvast";
              version = versionOverride;
              src = final.vast-sources.vast-release.version + "/pyvast";
              doCheck = false;
              propagatedBuildInputs = with python3Packages; [
                aiounittest
              ];
            });

          pyvast-latest = with final;
            (python3Packages.buildPythonPackage {
              pname = "pyvast";
              version = versionOverride;
              src = final.vast-sources.vast-latest.version + "/pyvast";
              doCheck = false;
              propagatedBuildInputs = with python3Packages; [
                aiounittest
              ];
            });

          vast-release = with final; (vast.override
            ({
              versionOverride = final.vast-sources.vast-release.version;
            }));

          vast-latest = with final; (vast.override ({
            versionOverride = final.vast-sources.vast-latest.version;
          }));
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
                } // cfg.settings;
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

                settings = mkOption {
                  type = types.attrsOf types.anything;
                  default = { };
                };

                package = mkOption {
                  type = types.package;
                  default = self.outputs.packages."${pkgs.system}".vast;
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
                "network-online.target"
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
                Restart = "always";
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
