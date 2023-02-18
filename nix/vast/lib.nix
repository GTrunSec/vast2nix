{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab.writers.lib) writeConfiguration;
  inherit (inputs) std self cells-lab;

  nixpkgs = inputs.vast-upstream.pkgs.appendOverlays [
    cell.overlays.default
  ];
in {
  inherit
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
