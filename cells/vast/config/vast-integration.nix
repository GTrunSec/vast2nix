{data ? "data"}: let
  zeek-command = "-N import zeek";
in {
  tests = {
    "Node Zeek conn log" = {
      tags = ["node" "import-export" "zeek"];
      steps = {
        command = zeek-command;
        input = "data/zeek/conn.log.gz";
      };
    };
  };
}
