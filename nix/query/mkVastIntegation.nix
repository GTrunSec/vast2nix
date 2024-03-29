{
  inputs,
  cell,
}: config: let
  inherit (inputs.cells-lab.writers.lib) writeShellApplication;
  inherit (inputs) nixpkgs;
in
  writeShellApplication {
    name = "vast-integration";
    runtimeInputs = [inputs.cells.vast.packages.vast-integration];
    text = ''
      vast-integration -s ${config} "$@"
    '';
  }
