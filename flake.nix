{
  nixConfig.extra-substituters = ["https://zeek.cachix.org" "https://vast.cachix.org"];
  nixConfig.extra-trusted-public-keys = [
    "zeek.cachix.org-1:w590YE/k5sB26LSWvDCI3dccCXipBwyPenhBH2WNDWI="
    "vast.cachix.org-1:0L8rErLUuFAdspyGYYQK3Sgs9PYRMzkLEqS2GxfaQhA="
  ];

  description = "https://github.com/tenzir/vast: 🔮 Visibility Across Space and Time – The network telemetry engine for data-driven security investigations.";

  inputs = {
    nixpkgs.follows = "cells-lab/nixpkgs";
    cells-lab.url = "github:GTrunSec/cells-lab";

    # std.url = "github:divnix/std?ref=refs/pull/164/head";
    std.follows = "cells-lab/std";
    std-data-collection.follows = "cells-lab/std-data-collection";
    org-roam-book-template.follows = "cells-lab/org-roam-book-template";
    std.inputs.n2c.follows = "n2c";

    n2c.url = "github:nlewo/nix2container";
  };

  inputs = {
    vast-upstream.url = "github:tenzir/vast";
  };
  outputs = {
    std,
    cells-lab,
    ...
  } @ inputs:
    std.growOn {
      inherit inputs;

      cellsFrom = ./nix;

      cellBlocks = with std.blockTypes;
        [
          (installables "packages")

          (nixago "nixago")

          (functions "devshellProfiles")

          (devshells "devshells")

          (runnables "entrypoints")

          (data "config")

          (files "models")

          (data "cargoMakeJobs")

          (files "configFiles")

          (files "templates")

          (functions "lib")

          (functions "overlays")

          (functions "nixosModules")
        ]
        ++ [
          # OCI soil
          # four layers of packaging
          (containers "containers")
          (containers "oci-images")

          # second layer of packaging
          (runnables "operables")
        ];
    } {
      overlays = (inputs.std.harvest inputs.self ["vast" "overlays"]).x86_64-linux;
      devShells = inputs.std.harvest inputs.self ["vast" "devshells"];
      nixosModules = (inputs.std.harvest inputs.self ["vast" "nixosModules"]).x86_64-linux;
      packages = inputs.std.harvest inputs.self ["vast" "packages"];
    };
}
