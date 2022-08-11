{
  inputs,
  cell,
}: let
  inherit (inputs) std nixpkgs data-merge;
in
  builtins.mapAttrs (_: std.std.lib.mkNixago) {
    phishing-url-jsonschema = {
      configData = cell.config.phishing-url;
      output = "test/schemas/phishing-url-jsonschema.json";
      format = "json";
      hook.mode = "copy";
    };
    vast-integration = {
      configData = cell.config.vast-integration;
      output = "test/schemas/vast-integration.yaml";
      format = "yaml";
      hook.mode = "copy"; # already useful before entering the devshell
    };
  }
