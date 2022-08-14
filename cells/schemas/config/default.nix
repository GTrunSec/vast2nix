{
  inputs,
  cell,
} @ args: let
  inherit (inputs) std nixpkgs data-merge;
  inherit (nixpkgs) lib;
  phishing-url-index = import ./phishing-url-index.nix args;
in {
  phishing-url = {
    "$id" = "phishing-url";
    "$schema" = "phishing-url-schema";
    "description" = "A phishing Url schema";
    "type" = "object";
    "properties" =
      builtins.mapAttrs (n: v:
        lib.recursiveUpdate v.schemas.data.validation {
        })
      (
        phishing-url-index
        // {
          Url.schemas.data.validation.type = "string";
          Date.schemas.data.validation = {
            "type" = "string";
            "format" = "date-time";
          };
        }
      );
  };
  vast-integration.tests = {
    phishing-url = {
      tags = ["schema" "json"];
      steps =  [ { command = "-N import"; input = "data.json";} ];
    };
  };
}
