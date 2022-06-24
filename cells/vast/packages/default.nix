{
  inputs,
  cell,
}: let
  inherit (inputs) cells-lab;
  nixpkgs = inputs.vast-nixpkgs.legacyPackages.appendOverlays [
    cell.overlays.default
    cell.overlays.vast
  ];
  vast-bin = nixpkgs.callPackage ./bin.nix {};
in {
  inherit
    (nixpkgs)
    vast-release
    vast-latest
    pyvast
    pyvast-latest
    ;
  inherit vast-bin;

  custom = cells-lab._builder.library.mkPaths {
    name = "vast-custom";
    paths = [
      # release latest bin
      nixpkgs.vast-bin
      # systemd.service
      cell.configFiles.customSystemd
      # config file -> vast.yaml
      cell.configFiles.customConfig
    ];
  };
}
