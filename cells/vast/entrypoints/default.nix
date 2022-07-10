{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab._writers.library) writeShellApplication writeGlowDoc;
  inherit (inputs) nixpkgs std self;
in {
  doc = writeGlowDoc {
    name = "Vast Docs";
    src = "${cell.library.nixpkgs.vast-sources.vast-latest.src}/web/docs";
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
