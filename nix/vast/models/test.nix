{
  l,
  inputs,
  cell,
}: let
  data = {
    a = "5";
    b = {
      c = "d";
    };
    c = {
      d = {
        a = "2";
        f = {
          a = "3";
          c = "4";
          f = {
            a = "5";
            b.b = "6";
          };
        };
      };
    };
  };

  mapAttrs = attrsSet: let
    checkValue = val: l.isAttrs val;
  in
    l.mapAttrsRecursiveCond (as: (!checkValue as)) (p: v:
      if checkValue v
      then {
        type = "record";
        values = mapAttrs v;
        tabs = (l.length (p ++ (l.mapAttrsToList (n: v': n) v))) - 1;
      }
      else v)
    attrsSet;

  final = mapAttrs data;

  mapAttrs_ = attrsSet: let
    checkValue = val: l.isAttrs val && l.hasAttr "values" val;
  in
    l.mapAttrsRecursiveCond (as: (!checkValue as)) (p: v:
      if checkValue v
      then writeAttr (mapAttrs_ v)
      else v)
    attrsSet;

  # tabs = l.genList (x: "\n") value.tabs;
  writeAttr = value: "{${l.concatStrings (l.mapAttrsToList (
      name': value': "${"
        ${name'}: ${value'},"}"
    )
    value.values)}
    }";

  write = value:
    l.concatStrings (l.mapAttrsToList (name: value: ''
        type ${name} = ${"${value}"}
      '')
      value);
in {
  inherit final write;
  a = mapAttrs_ {
    a = {
      b = "1";
      c = {a = "1";};
    };
  };
  c = mapAttrs_ final;
  f = final;
  g = l.mapAttrsRecursive (path: value: (l.length (path ++ [value]) - 1)) data;
  done = inputs.nixpkgs.writeText "test.text" (write (mapAttrs_ final));
}
