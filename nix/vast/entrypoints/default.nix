{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab._writers.lib) writeShellApplication writeGlowDoc;
  inherit (inputs) nixpkgs std self;

  l = inputs.nixpkgs.lib // builtins;
in {
  doc = writeGlowDoc {
    name = "Vast Docs";
    src = "${cell.lib.nixpkgs.vast-sources.vast-latest.src}/web/docs";
    tip = ''
      example: vast-doc `flag`
    '';
  };

  config-check = writeShellApplication {
    name = "mkdoc";
    runtimeInputs = [cell.packages.vast-bin];
    text = ''
      vast --config=${cell.configFiles.custom} "$@"
    '';
  };

  prod = std.lib.ops.mkOperable {
    package = cell.packages.vast-release;
    runtimeEnv = {
      VAST_DB_DIRECTORY = "/var/lib/vast";
      VAST_LOG_FILE = "/var/log/vast/server.log";
      VAST_PLUGINS = "all";
      WORKING_DIR = "/var/lib/vast";
    };
    # livenessProbe = std.lib.ops.writeScript {
    #   name = "vast-liveness-probe";
    #   text = ''
    #   '';
    # };
    # package has special meaning for the layer layout for OCI images.
    # package is likely to be much more volatile than runtime inputs.
    # It shouldn't sit with more stable layers and thereby not exacerbate on unnecessary storage.
    # It's already pretty hungry.
    runtimeScript = ''
      ${l.getExe cell.packages.vast-release} --endpoint=0.0.0.0:42000 start
    '';
  };
}
