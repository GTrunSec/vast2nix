{
  inputs,
  cell,
}: let
  inherit (cell.lib) nixpkgs;

  vast-bin = nixpkgs.callPackage ./bin.nix {};
  vast-integration = nixpkgs.callPackage ./vast-integration.nix {inherit vast-bin;};
  inherit (inputs.vast-upstream.packages) vast;
in {
  inherit
    (nixpkgs)
    pyvast
    pyvast-latest
    ;

  inherit
    vast
    vast-bin
    vast-integration
    ;
}
