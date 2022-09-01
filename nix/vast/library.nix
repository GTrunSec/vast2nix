{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab._writers.library) writeConfiguration;
  inherit (inputs) std nixpkgs self cells-lab;
  l = nixpkgs.lib // builtins;
  __inputs__ = cells-lab.main.library.callFlake "${(std.incl self [(self + /lock)])}/lock" {
    nixpkgs.locked = inputs.nixpkgs-lock.sourceInfo;
    nixpkgs-hardenedlinux.inputs.nixpkgs = "nixpkgs";
  };
in {
  inherit __inputs__ l;

  toYaml = source: name:
    (writeConfiguration {
      format = "yaml";
      language = "nix";
      inherit source name;
    })
    .data;

  toJSON = file:
    nixpkgs.runCommand "toJSON.json" {preferLocalBuild = true;} ''
      ${nixpkgs.remarshal}/bin/yaml2json -i ${file} -o $out
    '';

  nixpkgs = inputs.vast-nixpkgs.legacyPackages.appendOverlays [
    cell.overlays.default
    cell.overlays.vast
  ];
}
