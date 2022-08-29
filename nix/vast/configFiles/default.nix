{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs data-merge;
  inherit (nixpkgs) lib;
in {
  default = cell.library.toYaml (cell.config.default {
    db-directory = "/var/lib/vast";
    file-verbosity = "info";
  }) "vast";

  integration = cell.library.toYaml (cell.config.integration {}) "integration";
}
