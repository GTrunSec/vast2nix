{
  inputs,
  cell,
}: package: tag: attrs: let
  inherit (inputs) nixpkgs;
  inherit (inputs.std.lib.ops) mkOperable mkStandardOCI mkSetup mkUser;

  l = inputs.nixpkgs.lib // builtins;

  operable = mkOperable {
    inherit package;
    runtimeEnv = {
      VAST_PLUGINS = "all";
      VAST_DB_DIRECTORY = "/var/lib/vast";
      VAST_LOG_FILE = "/var/log/vast/server.log";
      WORKING_DIR = "/var/lib/vast";
    };
    # livenessProbe = writeScript {
    #   name = "vast-liveness-probe";
    #   text = ''
    #   '';
    # };
    # package has special meaning for the layer layout for OCI images.
    # package is likely to be much more volatile than runtime inputs.
    # It shouldn't sit with more stable layers and thereby not exacerbate on unnecessary storage.
    # It's already pretty hungry.
    runtimeScript = ''
      ${l.getExe package} --endpoint=0.0.0.0:42000 --plugins="$VAST_PLUGINS" "$@"
    '';
  };
in
  l.recursiveUpdate (mkStandardOCI rec {
    name = "ghcr.io/gtrunsec/vast";
    inherit tag operable;
    labels = {
      source = "github.com/gtrunsec/vast2nix";
    };
    options = {
      config.Volumes = {
        "/var/lib/vast" = {};
      };
      config.WorkingDir = "/var/lib/vast";
      config.ExposedPorts = {
        "42000/tcp" = {};
      };
    };
    setup = [
      # nixpkgs.coreutils
      # nixpkgs.bash
      (mkUser {
        user = "vast";
        group = "vast";
        uid = "1000";
        gid = "1000";
        # withHome = true;
        # withRoot = true;
      })
      (mkSetup "logs" [
          {
            path = "/var/log/vast";
            regex = "server.log";
            mode = "0777";
          }
        ] ''
          mkdir -p $out/var/log/vast
          touch $out/var/log/vast/server.log
        '')
    ];
    perms = [];
  }) attrs
