{
  description = "https://github.com/tenzir/vast: 🔮 Visibility Across Space and Time – The network telemetry engine for data-driven security investigations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    cells-lab.url = "github:GTrunSec/cells-lab";

    std.url = "github:divnix/std";
    data-merge.follows = "cells-lab/data-merge";
    yants.follows = "std/yants";
    std.inputs.kroki-preprocessor.follows = "cells-lab/kroki-preprocessor";
  };

  inputs = {
    vast-overlay.url = "github:tenzir/vast";
    vast-nixpkgs.follows = "vast-overlay/nixpkgs";
  };
  outputs = {
    std,
    cells-lab,
    ...
  } @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./cells;
      organelles = [
        (cells-lab.installables "packages")

        (std.functions "devshellProfiles")
        (std.devshells "devshells")

        (std.runnables "entrypoints")

        (std.data "config")
        (cells-lab.files "configFiles")

        (std.functions "library")

        (std.functions "overlays")

        (std.functions "nixosModules")
      ];
    } {
      overlays = inputs.std.deSystemize "x86_64-linux" (inputs.std.harvest inputs.self ["vast" "overlays"]);
      devShells = inputs.std.harvest inputs.self ["vast" "devshells"];
      nixosModules = inputs.std.deSystemize "x86_64-linux" (inputs.std.harvest inputs.self ["vast" "nixosModules"]);
      packages = inputs.std.harvest inputs.self ["vast" "packages"];
    };

  nixConfig.extra-substituters = ["https://zeek.cachix.org" "https://vast.cachix.org"];
  nixConfig.extra-trusted-public-keys = [
    "zeek.cachix.org-1:w590YE/k5sB26LSWvDCI3dccCXipBwyPenhBH2WNDWI="
    "vast.cachix.org-1:0L8rErLUuFAdspyGYYQK3Sgs9PYRMzkLEqS2GxfaQhA="
  ];
}
