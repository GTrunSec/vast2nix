{
  description = "Vast Cells development shell";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.devshell.url = "github:numtide/devshell?ref=refs/pull/169/head";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.cells.url = "github:GTrunSec/DevSecOps-cells";
  outputs = inputs:
    inputs.flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system: let
        cellsProfiles = inputs.cells.devshellProfiles.${system};
        devshell = inputs.devshell.legacyPackages.${system};
        nixpkgs = inputs.nixpkgs.legacyPackages.${system};
      in
        {
          devShell = devshell.mkShell {
            name = "Vast2nix";
            imports = [
              cellsProfiles.common
              (devshell.importTOML ./devshell.toml)
            ];
            commands = [ ];
            # {
            #   name = pkgs.vast-latest.pname;
            #   help = pkgs.vast-latest.meta.description;
            #   package = pkgs.vast-latest;
            # }
            packages = [ ];
            devshell.startup.nodejs-setuphook = nixpkgs.lib.stringsWithDeps.noDepEntry '''';
          };
        }
    );
}
