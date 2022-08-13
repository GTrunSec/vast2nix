{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  json = {
    "1" = {
      url = "string";
    };
    "2" = {
      url = "string";
    };
    "3" = "port";
    "4" = "number";
  };
in {
  vast-phishing-schema = nixpkgs.writeText "vast-phishing-url" (cell.library.writeVastSchema {
    config = json;
    fixConfig = {
      phishingUrl.type = "enum";
      phishingUrl.values.url = "duration #unit=s";
    };
  });
}
