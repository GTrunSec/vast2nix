{
  inputs,
  cell,
}: let
  nixpkgs = inputs.vast-nixpkgs.legacyPackages.appendOverlays [
    inputs.cells.vast.overlays.default
    inputs.cells.vast.overlays.vast
  ];
  inherit (inputs.cells-lab.main.library) inputs';
  inherit (nixpkgs) lib;

  files = builtins.attrNames (inputs'.xnlib.lib.files.filterFilesBySuffix
    "${nixpkgs.vast-sources.vast-latest.src}/web/cli"
    "md");

  splitName = s: f:
    lib.concatStringsSep s (map (f: let
        name = let
          name' = lib.removeSuffix ".md" f;
        in (
          if name' == "vast"
          then name'
          else (lib.removePrefix "vast-" name')
        );
      in ''
        "${name}") glow ${nixpkgs.vast-sources.vast-latest.src}/web/cli/${f}
        ;;
      '')
      f);

  flags = splitName " " files;
  names = splitName "\n -> " files;

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
  content
