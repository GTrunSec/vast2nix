{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells-lab._writers.library) writeConfiguration;
in {
  default =
    (writeConfiguration {
      name = "vast";
      format = "yaml";
      language = "nix";
      source = cell.config.default {
        db-directory = "/var/lib/vast";
        file-verbosity = "info";
      };
    })
    .data;
}
