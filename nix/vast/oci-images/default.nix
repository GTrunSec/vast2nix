{
  inputs,
  cell,
}: let
  inherit (inputs) std nixpkgs;
  inherit (inputs.std.lib.ops) mkOperable mkStandardOCI mkSetup mkUser;

  l = inputs.nixpkgs.lib // builtins;
in {
  prod = mkStandardOCI rec {
    name = "vast-release";
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
      nixpkgs.coreutils
      nixpkgs.bash
      (mkUser {
        user = "vast";
        group = "vast";
        uid = "1001";
        gid = "1001";
        withHome = true;
        # withRoot = true;
      })
      (mkSetup "logs" [
          {
            path = "/var/log/vast";
            regex = "server.log";
            mode = "0777";
          }
          {
            regex = "/var/lib/vast";
            mode = "0744";
            user = "vast";
            group = "vast";
          }
        ] ''
          mkdir -p $out/var/log/vast
          touch $out/var/log/vast/server.log
        '')
    ];
    perms = [];
    tag = "latest";
  };
}
