{
  inputs,
  cell,
}: let
  inherit (inputs) std nixpkgs data-merge;
in
  builtins.mapAttrs (_: std.lib.dev.mkNixago) {
    phishing-url-jsonschema = {
      configData = cell.config.phishing-url;
      output = "data/schemas/phishing-url-jsonschema.json";
      format = "json";
      hook.mode = "copy";
    };
    vast-integration = {
      configData = cell.config.vast-integration;
      output = "data/schemas/vast-integration.yaml";
      format = "yaml";
      hook.mode = "copy";
    };
  }
