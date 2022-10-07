{
  inputs,
  cell,
}: let
  inherit (cell.lib) nixpkgs;

  vast-bin = nixpkgs.callPackage ./bin.nix {};
  vast-integration = nixpkgs.callPackage ./vast-integration.nix {inherit vast-bin;};
in {
  inherit
    (nixpkgs)
    vast-release
    vast-latest
    pyvast
    pyvast-latest
    ;
  inherit
    vast-bin
    vast-integration
    ;
}
