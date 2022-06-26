{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab._writers.library) writeShellApplication;
  inherit (inputs) nixpkgs;
in {
  deploy-nix = writeShellApplication {
    name = "deploy-vast-nix";
    runtimeInputs = [nixpkgs.cargo-make];
    text = ''
      cargo make --makefile ${cell.configFiles.default} "$@"
    '';
  };
  deploy-user = let
    doc = nixpkgs.writeText "md" (nixpkgs.lib.fileContents ./deploy.md);
  in
    writeShellApplication {
      name = "deploy-vast";
      runtimeInputs = [nixpkgs.cargo-make nixpkgs.glow];
      text = ''
        if [ "$1" == "doc" ]; then
          glow ${doc}
        else
          cargo make --makefile ${cell.configFiles.default} "$@"
        fi
      '';
    };
}
