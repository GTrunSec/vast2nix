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
  test = cell.library.writeVastSchema "test.schema" {
    config = json;
    fixConfig = {
      phishingUrl.type = "enum";
      phishingUrl.values = ["1" "2" "3"];
      a.values = "timestamp";
    };
  };

  phishing-schema = cell.library.writeVastSchema "vast-phishing-url" {
    config = {
      phishing = {
        url = "string";
      };
    };
    fixConfig = {
    };
  };
}
