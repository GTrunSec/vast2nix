{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab._writers.library) writeShellApplication;
  inherit (inputs) nixpkgs;
in {
  config-check = writeShellApplication {
    name = "mkdoc";
    runtimeInputs = [cell.apps.vast-bin];
    text = ''
      vast --config=${cell.configFiles.custom} "$@"
    '';
  };
}
