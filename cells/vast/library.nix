{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab._writers.library) writeConfiguration;
  inherit (inputs) std nixpkgs self;
  inputs' =
    (std.deSystemize nixpkgs.system
      (import "${(std.incl self [
        (self + /lock)
      ])}/lock")
      .inputs)
    // inputs;
in {
  inherit inputs';

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
}
