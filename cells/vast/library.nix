{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab._writers.library) writeConfiguration;
in {
  toYaml = source:
    (writeConfiguration {
      name = "vast";
      format = "yaml";
      language = "nix";
      inherit source;
    })
    .data;
}
