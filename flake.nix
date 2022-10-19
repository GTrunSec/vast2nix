{
  description = "https://github.com/tenzir/vast: 🔮 Visibility Across Space and Time – The network telemetry engine for data-driven security investigations.";

  inputs = {
    nixpkgs.follows = "cells-lab/nixpkgs";
    cells-lab.url = "github:GTrunSec/cells-lab";

    # std.url = "github:divnix/std?ref=refs/pull/164/head";
    std.url = "github:divnix/std";
    org-roam-book-template.follows = "cells-lab/org-roam-book-template";
    n2c.follows = "std/n2c";
  };

  inputs = {
    vast-overlay.url = "github:tenzir/vast";
    vast-nixpkgs.follows = "vast-overlay/nixpkgs";
    users.follows = "std/blank";
  };
  outputs = {
    std,
    cells-lab,
    ...
  } @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks =
        [
          (std.blockTypes.installables "packages")

          (std.blockTypes.nixago "nixago")

          (std.blockTypes.functions "devshellProfiles")

          (std.blockTypes.devshells "devshells")

          (std.blockTypes.runnables "entrypoints")

          (std.blockTypes.data "config")

          (std.blockTypes.files "models")

          (std.blockTypes.data "cargoMakeJobs")

          (std.blockTypes.files "configFiles")

          (std.blockTypes.files "templates")

          (std.blockTypes.functions "lib")

          (std.blockTypes.functions "overlays")

          (std.blockTypes.functions "nixosModules")
        ]
        ++ [
          # OCI soil
          # four layers of packaging
          (std.blockTypes.containers "containers")

          # second layer of packaging
          (std.blockTypes.functions "operables")
        ];
    } {
      overlays = (inputs.std.harvest inputs.self ["vast" "overlays"]).x86_64-linux;
      devShells = inputs.std.harvest inputs.self ["vast" "devshells"];
      nixosModules = (inputs.std.harvest inputs.self ["vast" "nixosModules"]).x86_64-linux;
      packages = inputs.std.harvest inputs.self ["vast" "packages"];
    };

  nixConfig.extra-trusted-substituters = ["https://zeek.cachix.org" "https://vast.cachix.org"];
  nixConfig.extra-trusted-public-keys = [
    "zeek.cachix.org-1:w590YE/k5sB26LSWvDCI3dccCXipBwyPenhBH2WNDWI="
    "vast.cachix.org-1:0L8rErLUuFAdspyGYYQK3Sgs9PYRMzkLEqS2GxfaQhA="
  ];
}
