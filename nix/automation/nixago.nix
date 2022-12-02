{
  inputs,
  cell,
}: let
  inherit (inputs) std;
in {
  treefmt = std.presets.nixago.treefmt {
    configData.formatter.prettier = {
      excludes = [
        "data/*"
        "generated.json"
      ];
    };
    configData.formatter.nix = {
      excludes = ["generated.nix"];
    };
  };
  mdbook = std.presets.nixago.mdbook {
    configData = {
      book.title = "Vast2nix Doc";
    };
  };
  just = std.std.nixago.just {
    configData = {
      tasks = import ./tasks.nix;
    };
  };
}
