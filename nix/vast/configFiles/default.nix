{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs data-merge cells-lab;
  inherit (nixpkgs) lib;
in {
  default = cells-lab._writers.lib.writeConfig "vast.yaml" (cell.config.default {
    db-directory = "/var/lib/vast";
    file-verbosity = "info";
  });

  integration = cells-lab._writers.lib.writeConfig "vast-integration.yaml" (cell.config.integration {});
}
