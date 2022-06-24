{
  inputs,
  cell,
}: {
  config = cell.library.toYaml (inputs.data-merge.merge (cell.config.default {
      # coustom arguments with Yants type check;
      db-directory = ".cache/vast";
      file-verbosity = "info";
      endpoint = "127.0.0.1:4000";
    }) {
      vast = {
        # coustom settings; freeType merge
        max-resident-partitions = 8;
        plguins = ["all"];
        # file-verbosity = "sss";
      };
    });

  systemd = cell.config.systemd {
    __argPath__ = "/opt/vast";
    __argConfig__ = "/opt/vast/vast.yaml";
    __argDir__ = "/var/lib/vast";
  };
}
