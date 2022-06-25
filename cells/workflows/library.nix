{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab._writers.library) writeConfiguration;
in {
  toTOML = source:
    (writeConfiguration {
      name = "vast-cargo-make";
      format = "toml";
      language = "nix";
      inherit source;
    })
    .data;
}
