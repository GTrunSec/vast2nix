{
  inputs,
  cell,
}: let
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
}
