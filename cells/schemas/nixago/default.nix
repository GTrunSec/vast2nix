{
  inputs,
  cell,
}: let
  inherit (inputs) std nixpkgs data-merge;
in {
  phishing-url-jsonschema = std.std.lib.mkNixago {
    configData = cell.config.phishing-url;
    output = "test/schemas/phishing-url-jsonschema.json";
    format = "json";
    hook.mode = "copy"; # already useful before entering the devshell
  };
}
