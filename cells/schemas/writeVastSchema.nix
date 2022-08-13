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

  translator = t:
    if lib.hasAttr t jsonSchemaToVastSchema
    then jsonSchemaToVastSchema.${t}
    else t;

  writeAttr = value: t: "${t}{${lib.concatStrings (lib.mapAttrsToList (
      name': value': "
              ${name'}: ${translator value'},
        "
    )
    value)}}";
in
  with lib;
    lib.concatStrings (lib.mapAttrsToList (name: value: ''
        type ${name} = ${
          if (lib.isAttrs value.values)
          then "${writeAttr value.values value.type}"
          else (translator value.values)
        }
      '')
      fixAttrs)
