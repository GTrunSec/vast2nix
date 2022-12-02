{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.writers.lib) writeShellApplication;
  inherit (inputs) nixpkgs;
in {
  jsonschema = writeShellApplication {
    name = "check-schema";
    runtimeInputs = [nixpkgs.check-jsonschema];
    text = ''
      check-jsonschema --schemafile "$@"
    '';
  };
}
