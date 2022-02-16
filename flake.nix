{
  description = "🔮 Visibility Across Space and Time – The network telemetry engine for data-driven security investigations.";
  #https://github.com/tenzir/vast
  nixConfig.extra-substituters = "https://zeek.cachix.org";
  nixConfig.extra-trusted-public-keys = "zeek.cachix.org-1:w590YE/k5sB26LSWvDCI3dccCXipBwyPenhBH2WNDWI=";
  nixConfig = {
    flake-registry = "https://github.com/hardenedlinux/flake-registry/raw/main/flake-registry.json";
  };
  inputs = {
    flake-compat.flake = false;
    zeek-vast-src = {
      url = "github:tenzir/zeek-vast";
      flake = false;
    };
    vast-overlay = { url = "github:gtrunsec/vast/module-client"; };
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      flake-compat,
      zeek2nix,
      nixpkgs-hardenedlinux,
      vast-overlay,
      ...
    }
    @ inputs:
      with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          overlay = import ./nix/overlay.nix { inherit inputs system; };
          pkgs = inputs.nixpkgs.legacyPackages."${system}".appendOverlays [ overlay ];
        in
          with pkgs; rec {
            inherit overlay;

            packages = flake-utils.lib.flattenTree { inherit (pkgs) vast-release vast-latest pyvast pyvast-latest; };
            apps = {
              vast-release = {
                type = "app";
                program = "${pkgs.vast-release}/bin/vast";
              };
              vast-latest = {
                type = "app";
                program = "${pkgs.vast-latest}/bin/vast";
              };
            };
            defaultPackage = pkgs.vast-release;
            hydraJobs = { inherit packages; };
          }
      )
      // {
        nixosModules.vast = inputs.vast-overlay.nixosModules.vast;
        nixosModules.vast-client = inputs.vast-overlay.nixosModules.vast-client;
      };
}
