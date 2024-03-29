{
  inputs,
  cell,
}: {
  config,
  fixConfig ? {},
}: let
  inherit (inputs.nixpkgs) lib;

  mapRecord = c: (builtins.mapAttrs (_: v: {
      type = "record";
      values = v;
    })
    c);

  mapValues = c: (builtins.mapAttrs (_: v: {
      values = v;
    })
    c);

  jsonSchemaToVastSchema = {
    integer = "count";
    number = "count";
    data-time = "timestamp";
    boolean = "bool";
    array = "list<string>";
  };

  translator = v: t:
    if (builtins.isList v)
    then "${t}{
            ${enumValues v}
          }"
    else if (lib.hasAttr v) jsonSchemaToVastSchema
    then jsonSchemaToVastSchema.${v}
    else v;

  enumValues = v:
    lib.concatMapStrings (x: "${x},")
    v;

  writeAttr = value: t: "${t}{${lib.concatStrings (lib.mapAttrsToList (
      name': value': "${
        if (t != "enum")
        then "
        ${name'}: ${translator value' t},"
        else "${enumValues value'}"
      }"
    )
    value)}
    }";

  final = c:
    lib.concatStrings (lib.mapAttrsToList (name: value: ''
        type ${name} = ${
          if (lib.isString value)
          then "${translator value value.type}"
          else if (lib.isAttrs value.values)
          then "${writeAttr value.values value.type}"
          else (translator value.values value.type)
        }
      '')
      c);
in
  (final (mapRecord config)) + (final fixConfig)
