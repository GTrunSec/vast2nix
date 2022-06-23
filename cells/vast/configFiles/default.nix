{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs data-merge;
  inherit (inputs.cells-lab._writers.library) writeConfiguration;

  toYaml = source:
    (writeConfiguration {
      name = "vast";
      format = "yaml";
      language = "nix";
      inherit source;
    })
    .data;
in {
  default = toYaml (cell.config.default {
    db-directory = "/var/lib/vast";
    file-verbosity = "info";
  });

  custom = toYaml (data-merge.merge (cell.config.default {
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
}
