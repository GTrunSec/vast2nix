{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab.writers.lib) writeConfiguration;
  inherit (inputs) std self cells-lab;

  l = nixpkgs.lib // builtins;
  __inputs__ = cells-lab.common.lib.callFlake "${(std.incl self [(self + /lock)])}/lock" {
    nixpkgs.locked = inputs.nixpkgs.sourceInfo;
    nixpkgs-hardenedlinux.inputs.nixpkgs = "nixpkgs";
  };

  nixpkgs = inputs.vast-nixpkgs.legacyPackages.appendOverlays [
    cell.overlays.default
    cell.overlays.vast
  ];
in {
  inherit
    __inputs__
    l
    nixpkgs
    ;

  toJSON = file:
    nixpkgs.runCommand "toJSON.json" {preferLocalBuild = true;} ''
      ${nixpkgs.remarshal}/bin/yaml2json -i ${file} -o $out
    '';

  mkConfig = import ./config/mkConfig.nix args;

  mkIntegration = import ./config/integration.nix;

  writeSystemd = import ./configFiles/mkSystemd.nix args;

  mkCompose = import ./dockerComposes/mkCompose.nix args;

  mkOCI = import ./oci-images/mkOCI.nix args;
}
