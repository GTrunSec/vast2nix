{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab._writers.library) writeShellApplication;
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) vast;
  inherit (inputs) std data-merge;
  vast-integation = std.lib.dev.mkNixago {
    configData = {
      tests.phishing-url = {
        tags = ["schema" "json"];
        steps = [
          {
            command = "-N import -s ${inputs.cells.schemas.configFiles.phishing-schema} -t phishing json";
            input = nixpkgs.writeText "json" (builtins.toJSON {
              url = "https://google.com";
            });
          }
          {
            command = "-N export json";
          }
        ];
      };
    };
    output = "test/schemas/phishing-url-jsonschema.yaml";
    format = "yaml";
    hook.mode = "copy";
  };
in {
  test = cell.library.mkVastIntegation vast-integation.configFile;
}
