{
  inputs,
  cell,
} @ args: let
  inherit (inputs) data-merge;
  inherit (cell) library;
  inherit (inputs) nixpkgs;
  inherit (inputs.cells-lab.main.library) inputs';

  default = _args: {
    vast = inputs'.xnlib.lib.recursiveMerge [
      (import ./metrics.nix args _args)
      (import ./start.nix args _args)
      (import ./main.nix args _args)
    ];
  };
in {
  inherit default;
}
