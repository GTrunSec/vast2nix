{
  writeScriptBin,
  vast-sources,
  python3,
  vast-bin,
}: let
  py3 = python3.withPackages (ps:
    with ps; [
      coloredlogs
      jsondiff
      pyarrow
      pyyaml
      schema
    ]);
in
  writeScriptBin "vast-integration" ''
    ${py3}/bin/python ${vast-sources.vast-latest.src}/vast/integration/integration.py \
    --app ${vast-bin}/bin/vast "$@"
  ''
