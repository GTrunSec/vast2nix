{
  inputs = {
    vast-overlay.url = "github:tenzir/vast";

    nixpkgs.follows = "vast-overlay/nixpkgs";

    cells-lab.url = "github:GTrunSec/cells-lab";
    std.url = "github:divnix/std";

    data-merge.follows = "cells-lab/data-merge";
  };

  outputs = {std, ...} @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./cells;
      organelles = [
        (std.installables "packages")

        (std.functions "devshellProfiles")
        (std.devshells "devshells")

        (std.runnables "entrypoints")

        (std.functions "library")

        (std.functions "packages")

        (std.functions "overlays")

        (std.functions "nixosModules")
      ];
    } {
      overlays = inputs.std.deSystemize "x86_64-linux" (inputs.std.harvest inputs.self ["vast" "overlays"]);
      devShells = inputs.std.harvest inputs.self ["vast" "devshells"];
      nixosModules = inputs.std.deSystemize "x86_64-linux" (inputs.std.harvest inputs.self ["vast" "nixosModules"]);
      packages = inputs.std.harvest inputs.self ["vast" "packages"];
    };
}
