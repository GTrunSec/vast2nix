{
  inputs,
  cell,
}: let
  inherit (inputs.cells.vast.library) nixpkgs;
  inherit (inputs.cells-lab.main.library) inputs';
  inherit (nixpkgs) lib;

  getDocs = path: (builtins.attrNames (inputs'.xnlib.lib.files.filterFilesBySuffix
    "${nixpkgs.vast-sources.vast-latest.src}/web/docs/${path}"
    "md"));

  query = lib.flatten (map (p: (map (x: p + x) (getDocs p))) understand-vast-md);

  understand-vast-md =
    map (p: "understand-vast/" + p + "/")
    [
      ""
      "query-language/operators"
      "query-language/frontends"
      "data-model"
      "architecture"
      "architecture/cloud"
    ];

  splitName = s: f:
    lib.concatStringsSep s (map (f: let
        name = lib.removeSuffix ".md" f;
      in ''
        "${name}") glow ${nixpkgs.vast-sources.vast-latest.src}/web/docs/${f}
        ;;
      '')
      f);

  flags = splitName " " query;
  names = splitName "\n -> " query;

  content = ''
    case "''${1}" in
    ${flags}

    *)
      # shellcheck disable=all
      echo "`basename ''${0}`:usage: ${names}"
      exit 1 # Command to come out of the program with status 1
      ;;
    esac
  '';
in
  # query
  content
