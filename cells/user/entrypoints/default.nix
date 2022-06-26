{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab._writers.library) writeShellApplication;
  inherit (inputs) nixpkgs;
in {
  deploy = let
    doc = nixpkgs.writeText "md" (nixpkgs.lib.fileContents ./deploy-user.md);
  in
    writeShellApplication {
      name = "deploy-user";
      runtimeInputs = [nixpkgs.cargo-make nixpkgs.glow nixpkgs.cargo];
      text = ''
        if [ "$1" == "doc" ]; then
          glow ${doc}
        else
          cargo make --makefile ${cell.configFiles.deploy} "$@"
        fi
      '';
    };

  config = let
    doc = nixpkgs.writeText "md" (nixpkgs.lib.fileContents ./deploy-user.md);
  in
    writeShellApplication {
      name = "config-user";
      runtimeInputs = [nixpkgs.cargo-make nixpkgs.glow];
      text = ''
        # shellcheck disable=all
        if [ "$@" == "doc" ]; then
          glow ${doc}
        else
        bat --paging=never ${cell.configFiles.vast}
        fi
      '';
    };
}
