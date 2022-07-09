{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab._writers.library) writeShellApplication;
  inherit (inputs) nixpkgs;
in {
  doc = let
    doc = import ./doc.nix args;
  in
    writeShellApplication {
      name = "vast-doc";
      runtimeInputs = [nixpkgs.glow];
      text = doc;
    };
  config-check = writeShellApplication {
    name = "mkdoc";
    runtimeInputs = [cell.packages.vast-bin];
    text = ''
      vast --config=${cell.configFiles.custom} "$@"
    '';
  };
}
