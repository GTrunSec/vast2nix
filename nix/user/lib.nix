{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.writers.lib) writeConfiguration;
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
