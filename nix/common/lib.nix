{
  inputs,
  cell,
} @ args: let
  inherit (inputs.cells-lab.writers.lib) writeConfiguration;
  inherit (inputs) std self cells-lab;

  __inputs__ = cells-lab.common.lib.callFlake ./lib/lock {
    nixpkgs.locked = inputs.nixpkgs.sourceInfo;
    nixpkgs-hardenedlinux.inputs.nixpkgs = "nixpkgs";
  };
in {
  inherit
    __inputs__
    ;
}
