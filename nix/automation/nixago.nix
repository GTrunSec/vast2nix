{
  inputs,
  cell,
}: let
  inherit (inputs) std std-data-collection;
in {
  treefmt = std-data-collection.data.configs.treefmt {
    data.formatter.prettier = {
      excludes = [
        "data/*"
        "generated.json"
      ];
    };
    data.formatter.nix = {
      excludes = ["generated.nix"];
    };
  };
  mdbook = std-data-collection.data.configs.mdbook {
    data = {
      book.title = "Vast2nix Doc";
    };
  };
  just = std.lib.cfg.just {
    data = {
      tasks = import ./tasks.nix;
    };
  };
}
