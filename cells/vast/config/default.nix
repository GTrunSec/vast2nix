{
  inputs,
  cell,
} @ args: let
  inherit (inputs.std) dmerge;
  inherit (cell) library;
  inherit (inputs) nixpkgs;
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

  default = attrs:
    __inputs__.xnlib.lib.recursiveMerge [
      (filterValue "value" (import ./vast.nix args))
      (filterValue "value" (import ./caf.nix args))
      attrs
    ];
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
# {
#   a = {
#     b.c = { value = "hello"; des = "world"; };
#     d.e.f = { value = "hello2"; des = "world2"; };
#   };
#   a2 = {
#     b.c = "hello";
#     d.e.f = "hello2";
#   };
# }

