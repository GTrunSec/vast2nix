{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab._writers.library) writeShellApplication;
  inherit (inputs) nixpkgs;
in {
  deploy = writeShellApplication {
    name = "deploy-vast";
    runtimeInputs = [nixpkgs.cargo-make];
    text = ''
      cargo make --makefile ${cell.configFiles.deploy} "$@"
    '';
  };
  deploy-user = let
    doc = nixpkgs.writeText "md" (nixpkgs.lib.fileContents ./deploy-user.md);
  in
    writeShellApplication {
      name = "deploy-vast";
      runtimeInputs = [nixpkgs.cargo-make nixpkgs.glow];
      text = ''
        if [ "$1" == "doc" ]; then
          glow ${doc}
        else
          cargo make --makefile ${cell.configFiles.deploy-user} "$@"
        fi
      '';
    };

  deploy-user-config = let
    doc = nixpkgs.writeText "md" (nixpkgs.lib.fileContents ./deploy-user.md);
  in
    writeShellApplication {
      name = "deploy-config";
      runtimeInputs = [nixpkgs.cargo-make nixpkgs.glow];
      text = ''
        # shellcheck disable=all
        if [ "$@" == "doc" ]; then
          glow ${doc}
        else
        bat --paging=never ${inputs.cells.vast.configFiles.user-config}
        fi
      '';
    };
}
