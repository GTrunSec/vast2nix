{
  inputs,
  cell,
}: let
  inherit (inputs) std;
in {
  treefmt = std.std.nixago.treefmt {
    configData.formatter.prettier = {
      excludes = [
        "Manifest.toml"
        "Project.toml"
        "generated.json"
        "julia2nix.toml"
        "test/*"
      ];
    };
    configData.formatter.nix = {
      excludes = ["generated.nix"];
    };
  };
  mdbook = std.std.nixago.mdbook {
    configData = {
      book.title = "Vast2nix Doc";
    };
  };
}
