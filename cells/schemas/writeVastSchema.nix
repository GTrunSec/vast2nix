{
  inputs,
  cell,
}: {
  config,
  fixConfig ? {},
}: let
  inherit (inputs.nixpkgs) lib;

  fixAttrs = lib.recursiveUpdate (builtins.mapAttrs (_: v: {
      type = "record";
      values = v;
    })
    config)
  fixConfig;

  jsonSchemaToVastSchema = {
    integer = "count";
    number = "count";
    data-time = "timestamp";
    boolean = "bool";
  };

  translator = v: t:
    if (builtins.isList v)
    then "${t}{
            ${enumValues v}
          }"
    else if (lib.hasAttr v) jsonSchemaToVastSchema
    then jsonSchemaToVastSchema.${v}
    else v;

  enumValues = v: lib.concatMapStrings (x: "${x},")
    v;

  writeAttr = value: t: "${t}{${lib.concatStrings (lib.mapAttrsToList (
      name': value': "${
        if (t != "enum")
        then "
              ${name'}: ${translator value' t},
              "
        else "${enumValues value'}"
      }
        "
    )
    value)}}";
in
  with lib;
    lib.concatStrings (lib.mapAttrsToList (name: value: ''
        type ${name} = ${
          if (lib.isAttrs value.values)
          then "${writeAttr value.values value.type}"
          else (translator value.values value.type)
        }
      '')
      fixAttrs)
