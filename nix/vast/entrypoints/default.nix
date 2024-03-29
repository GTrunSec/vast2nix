{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab.writers.lib) writeShellApplication writeGlowDoc;
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
}
