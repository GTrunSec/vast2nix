{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs data-merge cells-lab;
  inherit (nixpkgs) lib;
in {
  default = cells-lab.writers.lib.writeConfig "vast.yaml" (cell.config.default {
    db-directory = "/var/lib/vast";
    file-verbosity = "info";
  });

  systemd = cell.lib.writeSystemd {
    __argBinPath__ = "/opt/vast";
    __argConfig__ = "/var/lib/vast/vast.yaml";
    __argDir__ = "/var/lib/vast/";
  };

  validation-error = cells-lab.writers.lib.writeConfig "vast.yaml" cell.config.validation-error;

  integration = cells-lab.writers.lib.writeConfig "vast-integration.yaml" (cell.lib.mkIntegration {});
}
