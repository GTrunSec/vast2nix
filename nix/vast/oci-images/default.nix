{
  inputs,
  cell,
}: let
  inherit (inputs) std nixpkgs;
  inherit (inputs.std.lib.ops) mkOperable mkStandardOCI mkSetup mkUser;

  l = inputs.nixpkgs.lib // builtins;
in {
  /*
  docker run --user vast -it --rm -p 42000:42000 \
  -v $(pwd)/test ghcr.io/gtrunsec/vast:latest start

  # https://www.redhat.com/sysadmin/debug-rootless-podman-mounted-volumes

  podman run -it --rm --userns=keep-id --group-add keep-groups --user vast \
  -p 42000:42000 -v $(pwd)/test:/var/lib/vast ghcr.io/gtrunsec/vast:latest start
  */
  prod = mkStandardOCI rec {
    name = "ghcr.io/gtrunsec/vast";
    operable = cell.operables.prod;
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
      nixpkgs.bash
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
          # {
          #   regex = "/var/lib/vast";
          #   mode = "0744";
          #   user = "vast";
          #   group = "vast";
          # }
        ] ''
          mkdir -p $out/var/log/vast
          touch $out/var/log/vast/server.log
        '')
    ];
    perms = [];
    tag = "latest";
  };
}
