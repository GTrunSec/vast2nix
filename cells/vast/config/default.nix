{
  inputs,
  cell,
} @ args: let
  inherit (inputs) data-merge;
  inherit (cell) library;
  inherit (inputs) nixpkgs;
  inherit (inputs.cells-lab.main.library) __inputs__;
  inherit (inputs.cells-lab.makes.library) makeSubstitution;
  default = _args: {
    vast = __inputs__.xnlib.lib.recursiveMerge [
      (import ./metrics.nix args)
      (import ./start.nix args)
      (import ./main.nix args)
      _args
    ];
  };
in {
  inherit default;

  systemd = env:
    makeSubstitution {
      name = "vast-systemd";
      inherit env;
      source = ./systemd.service;
    };

  integration = import ./vast-integration.nix;
}
