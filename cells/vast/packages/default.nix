{
  inputs,
  cell,
}: let
  nixpkgs = inputs.nixpkgs.appendOverlays [
    cell.overlays.default
    cell.overlays.vast
  ];
in {
  inherit
    (nixpkgs)
    vast-release
    vast-latest
    pyvast
    pyvast-latest
    ;
}
