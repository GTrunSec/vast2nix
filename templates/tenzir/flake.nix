{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    vast2nix.url = "/home/gtrun/ghq/github.com/GTrunSec/vast2nix";
    vast2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    {}
    // (
      flake-utils.lib.eachSystem ["x86_64-linux"]
      (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
          vast2nix = inputs.vast2nix."${system}";
        in {
          packages.mkEnv = vast2nix.vast.lib.__inputs__.dc.${system}.quarto.lib.mkEnv {
            r = ps:
              with ps; [
                # add your custom R packages here
                ggplot2
              ];
            python = ps:
              with ps; [
                # add your custom Python packages here
                pandas
              ];
            text = ''
              # write your custom bash script here
              quarto render "$@"
            '';
          };
        }
      )
    )
    // {
      overlays.default = final: prev: {};
    };
}
