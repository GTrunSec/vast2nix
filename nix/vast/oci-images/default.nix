{
  inputs,
  cell,
}: let
  inherit (inputs) std nixpkgs;
  l = inputs.nixpkgs.lib // builtins;
in {
  prod = std.lib.ops.mkStandardOCI rec {
    name = "vast-release";
    operable = cell.entrypoints.prod;
    options = {
      config.ExposedPorts = {
        "42000/tcp" = {};
      };
    };
    setup = [
      nixpkgs.bash
      (std.lib.ops.mkSetup "logs" [
          {
            path = "/var/log/vast";
            regex = "server.log";
            mode = "0777";
          }
          {
            path = "/var/lib/vast";
            regex = ".*";
            mode = "0777";
          }
        ] ''
          mkdir -p $out/var/log/vast
          mkdir -p $out/var/lib/vast
          touch $out/var/log/vast/server.log
        '')
    ];
    perms = [];
    tag = "latest";
  };
}
