{
  inputs,
  cell,
} @ args: attrsSet: mergeAttrs: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells-lab.common.lib) __inputs__;

  l = nixpkgs.lib // builtins;

  filterValue = v': attrsSet: let
    checkValue = val: l.isAttrs val && l.hasAttr v' val;
  in
    l.mapAttrsRecursiveCond (as: (!checkValue as)) (p: v:
      if checkValue v
      then v.value
      else v)
    attrsSet;

  config = attrsSet:
    inputs.cells-lab.inputs.xnlib.lib.attrsets.recursiveMerge [
      (filterValue "value" (import ./vast.nix args attrsSet))
      (filterValue "value" (import ./caf.nix args))
      mergeAttrs
    ];

  mkConfig = config: (let
    y = inputs.cells-lab.yants.lib;
  in
    l.recursiveUpdate config (l.mapAttrsRecursive (path: value: let
      name = builtins.elemAt path ((builtins.length path) - 1);
    in
      value name (l.getAttrFromPath path config)) {
      # add your validation config
      vast.store-backend = y.enumCheck ["segment-store" "archive"];
      vast.console-sink = y.enumCheck ["stderr" "journald" "syslog"];
    }));
in
  mkConfig (config attrsSet)
