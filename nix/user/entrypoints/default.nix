{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.writers.lib) writeShellApplication;
  inherit (inputs) nixpkgs;
in {
  deploy = let
    doc = nixpkgs.writeText "md" (nixpkgs.lib.fileContents ./deploy.md);
  in
    writeShellApplication {
      name = "deploy-user";
      runtimeInputs = [nixpkgs.cargo-make nixpkgs.glow nixpkgs.cargo];
      text = ''
        if [ "$1" == "doc" ]; then
          glow ${doc}
        fi
      '';
    };

  config = let
    doc = nixpkgs.writeText "md" (nixpkgs.lib.fileContents ./config.md);
  in
    writeShellApplication {
      name = "config-user";
      runtimeInputs = [nixpkgs.glow nixpkgs.bat];
      text = ''
        case "$@" in
        "doc") glow ${doc}
        ;;
        "vast") bat --paging=never ${cell.configFiles.vast}
        ;;
        "deploy") bat --paging=never ${cell.configFiles.deploy}
        ;;
        esac
      '';
    };
}
