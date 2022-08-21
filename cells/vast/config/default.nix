{
  inputs,
  cell,
} @ args: let
  inherit (inputs.std) dmerge;
  inherit (cell) library;
  inherit (inputs) nixpkgs std;
  inherit (inputs.cells-lab.main.library) __inputs__;
  inherit (inputs.cells-lab.makes.library) makeSubstitution;
  l = nixpkgs.lib // builtins;

  filterValue = v': attrsSet: let
    checkValue = val: l.isAttrs val && l.hasAttr v' val;
  in
    l.mapAttrsRecursiveCond (as: (!checkValue as)) (p: v:
      if checkValue v
      then v.value
      else v)
    attrsSet;

  default = _args:
    __inputs__.xnlib.lib.recursiveMerge [
      (filterValue "value" (import ./vast.nix args _args))
      (filterValue "value" (import ./caf.nix args))
    ];

  trace = t: l.trace t t;
in {
  inherit default;

  test-config = cell.config.mkConfig (dmerge.merge (default {
      dataDir = "/tmp/vast";
      verbosity = "debug";
    }) {
      # validation: error
      # vast.store-backend = "archive";
    });

  mkConfig = config: (let
    y = inputs.cells-lab.yants.library;
  in
    l.recursiveUpdate config (l.mapAttrsRecursive (path: value: let
      name = builtins.elemAt path ((builtins.length path) - 1);
    in
      value name (l.getAttrFromPath path config)) {
      # add your validation config
      vast.store-backend = y.enumCheck ["segment-store" "archive"];
    }));

  systemd = env:
    makeSubstitution {
      name = "vast-systemd";
      inherit env;
      source = ./systemd.service;
    };

  integration = import ./vast-integration.nix;
}
