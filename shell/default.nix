{ inputs
, devshell
, pkgs
, system
}:
let
  cellsProfiles = inputs.cells.devshellProfiles.${system};
in
devshell.mkShell {
  imports = [ (devshell.importTOML ./devshell.toml)
              cellsProfiles.common
            ];
  commands =
    with pkgs;
    [
      # {
      #   name = pkgs.vast-latest.pname;
      #   help = pkgs.vast-latest.meta.description;
      #   package = pkgs.vast-latest;
      # }
    ];
}
