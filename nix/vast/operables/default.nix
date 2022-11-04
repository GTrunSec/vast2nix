{
  inputs,
  cell,
}: let
  inherit (inputs.std.lib.ops) mkOperable writeScript;

  l = inputs.nixpkgs.lib // builtins;
in {
  prod = mkOperable {
    package = cell.packages.vast-latest;
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
      ${l.getExe cell.packages.vast-release} --endpoint=0.0.0.0:42000 --plugins="$VAST_PLUGINS" "$@"
    '';
  };
}
