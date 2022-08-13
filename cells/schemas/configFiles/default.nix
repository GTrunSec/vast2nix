{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  json = {
    "1" = {
      url = "string";
      add = "port";
    };
    "2" = {
      url = "string";
      add = "port";
    };
    "3" = "port";
    "4" = "number";
  };
in {
  vast-phishing-schema = nixpkgs.writeText "vast-phishing-url" (cell.library.writeVastSchema {
    config = json;
    fixConfig = {
      phishingUrl.type = "enum";
      phishingUrl.values = ["1" "2" "3"];
    };
  });
}
