{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab._writers.library) writeConfiguration;
  inherit (inputs) std nixpkgs self;
  __inputs__ =
    (std.deSystemize nixpkgs.system
      (import "${(std.incl self [(self + /lock)])}/lock").inputs)
    // inputs;
in {
  inherit __inputs__;
  # inherit __inputs__;
  toYaml = source:
    (writeConfiguration {
      name = "vast";
      format = "yaml";
      language = "nix";
      inherit source;
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
