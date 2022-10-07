{
  inputs,
  cell,
}: let
  inherit (inputs) data-merge;
in {
  config = inputs.cells.vast.lib.toYaml (data-merge.merge (inputs.cells.vast.config.default {
      # coustom arguments with Yants type check;
      db-directory = ".cache/vast";
    }) {
      vast = {
        # coustom settings; freeType merge
        max-resident-partitions = 8;
        plugins = data-merge.append ["all"];
        # file-verbosity = "sss";
      };
    });

  systemd = inputs.cells.vast.config.systemd {
    __argPath__ = "/opt/vast";
    __argConfig__ = "/opt/vast/vast.yaml";
    __argDir__ = "/var/lib/vast";
  };
}
