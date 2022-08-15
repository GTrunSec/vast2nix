{
  inputs,
  cell,
}: config: let
  inherit (inputs.cells-lab._writers.library) writeShellApplication;
  inherit (inputs) nixpkgs;
in
  writeShellApplication {
    name = "vast-integration";
    runtimeInputs = [inputs.cells.vast.packages.vast-integration];
    text = ''
      vast-integration -s ${config} "$@"
    '';
  }
